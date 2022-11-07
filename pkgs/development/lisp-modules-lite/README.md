# Nix Packages Lite

Nix-only implementation of a lispDerivation builder.

Called Lite because it’s relatively low complexity (LoC and layers of indirection) compared to the other two lisp module implementations (no QuickLisp, no auto generation, only one lisp supported for now).

This is an experiment to discover what a Lisp-in-Nix system would look like, if QuickLisp didn’t exist. I started with a stdenv.mkDerivation and worked my up from there.

It draws on lisp-modules-new for inspiration in places.

## Features / Anti-features

What you think of this depends entirely on your point of view:

- Leaves source repositories intact: no .asd file mangling, no inspection of lisp code, no parsing to extract package structure or dependencies
- No QuickLisp (controversial)
- Tight integration with ASDFv3:
  - tests defined using `test-op`
  - binary output using `:build-operation program-op`
  - regular .asd output (for libraries) by default
  This convention is used by almost every existing major package.
- No pre-build step to check-in .nix code: the .nix you see is everything you need
- All packages are independently tracked, loaded from authoritative source, and can (must!) be independently updated
- Supports multi-system source repositories (e.g. `cl-async` exports `cl-async`, `cl-async-ssl`, `cl-async-repl`) with different dependencies
- Fully relies ASDFv3 for finding systems: no path or system name rewriting in code
- Automatic dependency resolution of all lisp modules
- Automatic “deduplication” of lisp modules in dependency graph (i.e. any source derivation is only ever included once, and all systems for which it’s being loaded are passed in that one single call)

The lack of a pre-build step here may sound like a “feature” but all that means is that the job of updating packages is left to humans. The pre-build step was just there to reuse the effort done by Zach in maintaining QuickLisp. Throwing that away means, sure, no pre-build step, but also no easy updating of all systems at the same time.

## Usage

This package (lisp-modules-lite) makes a distinction between Nix *derivations* and Lisp *systems*:

- **derivation**: A Nix concept. It is a single atomic "block" of "code": it can be just the source code, or a pre-built package ready to use.
- **system**: A Common Lisp (actually an ASDF) concept. It is CL’s closest relative to e.g. a Python "package". Confusingly: Nix also has a concept of system, e.g. `x86_64-darwin`. It’s an OS+Architecture description. Because of that confusion, I try to call a Lisp system `lispSystem` in the code, instead of `system`.
- **package**: Very confusing word which I avoid. It can mean “Lisp package” which is sort-of-but-not-really close to “namespaces” in other languages, or it can mean a Nix derivation. Don’t use this word.

### Single derivation

See the `examples` directory for demonstrations on how to use this builder.

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite:

lispDerivation {
  lispSystem = "my-system";
  lispDependencies = [ alexandria arrow-macros ];
  src = ./.;
}
```

If your package defines multiple systems that you want to export, you can define them all:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite:

lispDerivation {
  lispSystems = [ "foo-a" "foo-b" ];
  lispDependencies = [ alexandria arrow-macros ];
  src = ./.;
}
```

### Multi-derivation

If your systems have different dependencies you can either:
- "just include all of them" in a single derivation (easiest solution of course), or
- specify separate systems entirely:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs.lispPackagesLite:

lispMultiDerivation {
  systems = {
    foo = {};
    foo-b = {
      lispDependencies = [ alexandria ];
    };
    foo-c = {
      lispSystem = "foo/c";
      lispDependencies = [ foo-b fiveam ];
    };
  };
  src = ./.;
}
```

Note:
- The system name is automatically derived from the attribute key name in the `systems` set
- You can override it using a `lispSystem` key, as per
- You can omit `lispDependencies` entirely if you have none
- You can include other systems defined in the same block, as long as there is no circular dependency chain
- This is only useful if your separate systems have different lispDependencies. If they don’t, just create a regular `lispDerivation` with `lispSystems = [ "foo-a" "foo-b" ]`.

## Output: binary vs .fasl files

Is your program itself intended to be used as a dependency? Then you don’t need to do anything special: pre-compiled .fasls will be left next to each .lisp file, and you can include your derivation itself as a `lispDependencies` entry for another lisp dervation.

Do you want to output a single executable, instead? This is natively supported by ASDF, so you can leverage that. See [best practices][best practices] to configure ASDF. You can use a custom `installPhase` to only copy out the resulting binary to your `$out`, if you want to avoid the build noise. See the `make-binary` example in this project.

## Testing

Make sure your ASDF defines tests as per the standard ASDF conventions, see [best practices][best practices].

To enable a derivation’s checks, get its `enableCheck` property:

```
$ nix-build -A alexandria.enableCheck
```

This isn’t quite as elegant as `overrideAttrs (_: { doCheck = true; } )`, mostly because my Nix-fu isn’t at that level yet. WIP.

## TODO

### Important

- Get all packages’ tests passing
- More packages (sub-todo: specify which packages are must-haves)
- Don't clobber existing `buildPhase` etc.
- Other lisps (currently hard-coded to SBCL)

### Nice-to-have

- An example showing fasl-only building, no binary
- Complete the list of "standard mkDerivation args" (dontUnpack, ...)
- Don’t use `CL_SOURCE_REGISTRY` but use source map files?
- Don’t clobber existing `CL_SOURCE_REGISTRY`
- Document how to overwrite a package
- Using that: in the test-all, can we "inject" a check=true version of every package into the entire chain? Instead of building every package in test mode separately, but have each of them depend on non-checking packages?

## Motivation

Common Lisp (ASDFv3) and the common Nix derivation idiom are fundamentally at odds: Nix packages are commonly one-repository-one-package (or to be precise "one derivation one package"). ASDFv3 on the other hand has no problems exporting multiple packages ("systems") from a single repository. If you map that directly to a single derivation, you either have to duplicate dependencies across multiple derivations, or build too much code when you don't need it.

Let's say you have a project that defines multiple systems. What do you build?

- every possible derivation? Problem: you might not /want/ to build certain subsystems at all, particularly if both (the final project doesn’t need them) AND (they can’t be built on your particular system).
- only one possible derivation? Problem: aside from getting into the ugly weeds of "which derivations does this package actually export vs which are just internal" (see e.g. cl-async, with cl-async-ssl (external) and cl-async-util (internal)), the real problem is when one single repository defines multiple systems in one .asd file (again see cl-async), you could end up loading e.g. cl-async-util from the derivation that only pre-compiled cl-async-base, and Lisp will say, "Ok this directory DOES define cl-async-util, it just hasn’t pre-compiled it yet, so let me just do that right now!", try to write in the /nix/store, and fail. There is no sane way out of this post-facto. I call this "the cl-async issue".

The other lisp module implementations are smart about which package defines which systems. Based on QuickLisp, they export only those systems which are actually external. Unfortunately this isn't fool proof (see "https://github.com/NixOS/nixpkgs/pull/196818").

This implementation, on the other hand, does nothing smart at all. It treats all derivations and their source as a black box. You explicitly list which systems it exports, and that's it. It relies on ASDF to find those systems in those derivations.

The downside is a convoluted Nix implementation to figure out the actual dependency tree, particularly when multiple systems live in the same source derivation. To solve The Cl-async Issue, you need to ensure there is only ever exactly one copy of cl-async in the dependencies of the final project. This is a struggle in Nix, although it is possible. Notably this is done purely through the explicit dependencies as specified in the .nix hierarchy: no QuickLisp database nor .asd file introspection is done whatsoever.

## Why not QuickLisp?

QuickLisp and Nix solve the same problem: dependency management. The main benefit of QuickLisp for an end user is "just list your dependencies, and you're good to go": Nix offers the same.

QuickLisp faces limitations that Nix doesn't need to worry about. Notably, it must be bootstrappable from pure Common Lisp without any dependencies. It has a low bus factor (basically just the one benevolent maintainer: Zach Beane). A discussion on this topic was held in 2016 on [Hacker News](https://news.ycombinator.com/item?id=13097333), and the comments ring just as true in 2022. Notably, someone laments the lack of alternative. I believe Nix can fill that gap.

The other lisp modules leverage QuickLisp which helps bootstrap the list of packages and "known good versions", and updates. In this package, there are no special cases: every package must be included, managed and updated manually.

But perhaps the most important reason to omit QL is “because there are already two other modules that rely on QL and I wanted to try it without.”

## Links

[best practices]: https://github.com/fare/asdf/blob/master/doc/best_practices.md
