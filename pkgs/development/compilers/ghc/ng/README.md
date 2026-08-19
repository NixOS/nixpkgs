# GHC, built as separate packages

This builds GHC without hadrian: one derivation per sub-package, using the
ordinary Haskell `generic-builder.nix`, with the toolchain described by
`ghc-toolchain` rather than by autoconf.

It is the GHC analogue of `../gcc/ng`, which splits the GCC compiler proper from
`libgcc`/`libstdc++`. The reference for *what* to build is
[stable-haskell/ghc's Makefile][sh], which does the same thing with
`cabal-install`. They had to patch cabal-install heavily -- a stage-aware
solver, `--with-build-compiler`, dropping the non-reinstallable hard constraints.
We need none of that: nixpkgs' package-set fixpoint already *is* the solver, and
`generic-builder.nix` drives `Setup.hs` directly.

[sh]: https://github.com/stable-haskell/ghc/blob/stable-ghc-9.14/Makefile

## Layout

Each package is a directory:

```
common/packages/ghc-toolchain-bin/generated-package.nix   # verbatim cabal2nix
common/packages/ghc-toolchain-bin/emit-settings-json.patch
```

`generated-package.nix` is written by
`maintainers/scripts/haskell/regenerate-ghc-ng-packages.sh` and is never
hand-edited; `common/overlay.nix` supplies `src`, `postUnpack`, every `*.patch`
beside it, and the occasional metadata fix. Patches are rooted at their own
package directory and belong to exactly one component, so they can go upstream
one at a time -- and so there is no patch-splitting machinery of the kind the
freebsd and illumos trees carry.

## Where things live

The boot libraries are not in a scope of their own. `base`, `rts`, `ghc-prim`,
`ghc-internal`, `template-haskell` and the rest are Hackage-namespace package
names, and they go in the ordinary Haskell package set for their compiler,
replacing the `= null` entries under `# Disable GHC core libraries` in
`haskell-modules/configuration-ghc-*.nix`.

Only things that are *not* package names get a nixpkgs-specific home, and they
are marked with a leading underscore:

| attribute | what it is |
|---|---|
| `<set>.ghc` | the GHC **library** (`compiler/ghc.cabal`), like any other package |
| `<set>._wrappers.ghc` | the wrapped compiler you actually invoke |
| `<set>._tools.*` | `deriveConstants`, `genapply`, `genprimopcode`, `ghc-toolchain-bin`, `unlit`, `hsc2hs` |

## The `_` prefix means "off by one"

A Haskell package set is indexed by the platform its *libraries* are built for.
The things under `_` are not: they are build-hosted.

This is not new. nixpkgs already does it, silently:

```
pkgs.pkgsCross.aarch64-multiplatform.haskell.packages.ghc9141.ghc
  => aarch64-unknown-linux-gnu-ghc-9.14.1     # build-hosted, aarch64-targeting
```

because `haskell-packages.nix` instantiates every set with `ghc = bh.compiler.X`
out of `buildPackages`, and `make-package-set.nix` then excludes `ghc` from
splicing precisely so it stays that way. The underscore names that fact instead
of leaving it to be discovered.

The payoff: **a compiler targeting T is just the `_wrappers` of the T-indexed
set.** There is no target axis anywhere -- no `targetPackages`, no
`pkgsBuildTarget` reach, no forward links. Everything is build and host only, by
construction. It also lets every set for one GHC version share a single
`buildHaskellPackages`, since `_tools` depends on the version and not the target.

## Splicing hazards

`__spliced` is consulted **only** for `mkDerivation` dependency lists
(`nativeBuildInputs` -> `buildHost`, `buildInputs` -> `hostTarget`, ...). Anything
used as a *string path* silently gets the host-target instance. `generic-builder`
is full of these (`--with-ghc=`, `--with-hsc2hs=`), and we add `DERIVE_CONSTANTS=`
and `GENAPPLY=`. Each must name `buildHaskellPackages.<x>` explicitly.

The store name is the check: a build-platform instance whose name carries no
platform suffix is the tell.

## The source tree needs no `./configure`

`common/src.nix` produces a `stdenvNoCC`, platform-independent tree. It takes no
compiler and runs no `configure`, because:

- GHC's `configure` refuses to start without a bootstrap GHC and probes a full C
  toolchain, neither of which the substitutions need. Depending on them would
  make the tree per-compiler and per-platform.
- **Hadrian does not use `configure` for this either.**
  `hadrian/src/Rules/Generate.hs:templateRules` templates the same files by plain
  variable interpolation, and that is the list `src.nix` reproduces.

Everything substituted is a pure function of the version string. Watch out for
`@ghc@`, `@base@`, `@ghci@` and friends in `.cabal` descriptions -- those are
Haddock monospace markup, not variables.

`configure` does do one substantive thing besides templating, and `src.nix`
reproduces it: fanning `utils/fs/fs.{c,h}` out to the four packages whose
`.cabal` files claim them as their own sources (`configure.ac:594-597`).

`autoreconf` still runs for `.`, `rts` and `libraries/ghc-internal`, because
`rts` and `ghc-internal` are `build-type: Configure` and Cabal runs those
scripts at build time.

## `lib/settings` is JSON, merged with jq

`lib/settings` is not a function of the toolchain. Alongside the compiler paths,
it carries facts only the build knows -- from a real GHC 9.14.1:

```
("base unit-id","base-4.22.0.0-95fb")     -- a hash of the base that got built
("RTS ways","v thr thr_debug ... dyn")    -- the ways that got built
("Relative Global Package DB","package.conf.d")
```

So it is assembled from two sources:

- `ghc-toolchain-bin --output-settings-json` emits the toolchain-derived subset
  (see `patches/settings-json.patch`).
- Nix emits the build-state entries.
- `jq` merges them **inside a derivation** -- so no import-from-derivation,
  even though one input is a build artefact.

GHC reads either format: the patch adds a JSON object parser beside
`maybeReadFuzzy` in `ghc-boot`, and `GHC.Settings.IO` and `ghc-pkg` try JSON
first and fall back. Existing settings files keep working, which makes this a
format migration rather than a break.

Contrast stable-haskell's `--output-settings`, which emits the whole file from
the `Target` alone and hardcodes the build-dependent entries -- `base unit-id`
becomes `""`, which means a compiler that cannot find `base`.
