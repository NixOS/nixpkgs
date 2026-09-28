# GCC Next-Generation

> This read-me assisted by: Claude Code (Claude Opus 5)

Experimental split GCC package set, based on the LLVM package set design.

The monolithic `gcc` derivation builds the compiler and every runtime library in one go, so a change to the target libc rebuilds the compiler too.
This set separates them — `gcc`, `libgcc`, `libstdcxx` and the rest are individual packages — so the compiler stops depending on the libc, and each piece can be rebuilt on its own.
Because GCC is not a multi-target compiler — a single target is baked into the binary with CPP — we still need to rebuild it more than we do LLVM, but someday that should change.

A platform opts in with `useGccNG`, in the same way it would opt into `useLLVM`.

## The bootstrap chain

The libc and libgcc depend on each other: a libc's own sources call into libgcc for integer and floating-point helpers and for stack unwinding, and a libgcc that can use the libc's threads needs the libc.

The way out we currently use is the same one the LLVM set takes with `compiler-rt-no-libc` and `compiler-rt-libc` — build the runtime twice, either side of the libc.
It is unclear whether this works in general to resolve the circularity, but we shall see.

That gives four compilers, each one step further along:

| compiler | libc | libgcc | used to build |
|---|---|---|---|
| `gccNoLibgcc` | headers, or nothing | — | `libgcc-no-libc` |
| `gccWithLibgcc` | headers, or nothing | `libgcc-no-libc` | the libc |
| `gccWithLibcAndBasicLibgcc` | real | `libgcc-no-libc` | `libgcc-libc` |
| `gccWithLibc` / `gcc` | real | `libgcc-libc` | everything else |

`libgcc` resolves to `libgcc-libc` wherever a libc exists; only those first three stages ever see `libgcc-no-libc`.
The bootstrap one is single-threaded and compiled against the libc's headers at best, so it is not intended for use beyond building the libc.

Nothing is passed down to say which stage is which.
It follows from the compiler: each package reads `stdenv.cc.libc` and needs no flag of its own.
That is also how the two `libgcc`s differ — same expression, different `stdenv`.

## Where the pre-libc stage is written down

`binutilsNoLibc` carries `preLibcHeaders` as its `libc`: the header-only stand-in for platforms that have one, and nothing at all for platforms that do not.
`wrapCCWith` defaults `libc` to `bintools.libc`, so the bootstrap compilers inherit it, and everything built with them reads `stdenv.cc.libc`.

Setting a sysroot as well is unusual for nixpkgs, since headers normally reach a compiler through the wrapper, as they do here.
It is needed because `gcc/configure` takes `target_header_dir` from `--with-sysroot`, and `target_header_dir` is what decides `inhibit_libc`.
A libgcc built with `inhibit_libc` still compiles, links and installs, just with pieces silently missing.

Given that, the sysroot is derived from `stdenv.cc.libc` too, so it cannot disagree with the headers.

## Threading

The threading model comes from whatever provides the threads, which declares it as `passthru.threadModel`; `libgcc` reads it from there, and `libstdcxx` takes both the model and the generated `gthr-default.h` from `libgcc`.

Usually that is the libc.
Where the libc's own threading is not what we want, a separate library supplies it, and `libgcc` is given it as the `threads` argument, which takes precedence.
MinGW is the case in point: its libc offers only `win32`, so we build against `windows.mcfgthreads` and get `mcf`, the same choice the monolithic `gcc` makes through `threadsCross`.
Unlike `threadsCross`, the model is not spelled out at the use site — the package declares its own, exactly as a libc does.

That library is built with `windows.crossThreadsStdenv`, which on a `useGccNG` platform is stage 3 of the bootstrap chain — the same compiler that then builds the threaded `libgcc`.
Being plain C with no threading model of its own, it does not mind that stage 3's libgcc has none, and that is what keeps the arrangement from being circular.

Reading it from the compiler instead, with `$CC -v | sed -n 's/^Thread model: //p'`, reports the wrong component: in this set the compiler is configured separately from libgcc, so the two can disagree.
A platform with nothing to declare a model gets `single`.

## Relationship to the monolithic set

Both are packaged from the same sources and, for now, the same version: `gccNGPackages` tracks `default-gcc-version` with no fallback, so bumping the monolithic default past what is packaged here is an evaluation error rather than a silent version skew.

Nothing selects GGN NG yet by default.
The plan is for very exotic package sets to switch to this first.
The main tier-1 native Linux package sets cached on `cache.nixos.org` will come later.

### Patches

Several of these are conditional on the target platform, following the monolithic set.
General Nixpkgs policy is to apply patches unconditionally where possible, and we probably should too.
But out of an abundance of caution we're matching the monolithic GCC for now.

TODO: apply them whatever the target.
The ones that are gated touch files no other target compiles -- `gcc/config/i386/cygwin.h`, `libgcc/config.host` -- so it should just work.

`libssp-noshared-musl32.patch` is the exception either way: it rewrites `LINK_SSP_SPEC` in `gcc/gcc.cc`, which every target compiles, so it cannot become unconditional without changing what every other target links.

### Patches the monolithic set has and this one does not

Most of `../patches/default.nix` is not applied here.
Some of it this set does not need; three were real gaps and have since been copied in.
The ones that have been looked at:

| patch | status | why |
|---|---|---|
| `gcc-12-no-sys-dirs.patch`, `13/no-sys-dirs-riscv.patch` | applied | Needed for a native build, not a cross one. `cppdefault.cc` drops `LOCAL_INCLUDE_DIR` and `NATIVE_SYSTEM_HEADER_DIR` by itself when `CROSS_DIRECTORY_STRUCTURE` is defined and no sysroot is, and `/lib/` and `/usr/lib/` reach `startfile_prefixes` only under `*cross_compile == '0' \|\| target_system_root`. We pass no sysroot, so a cross compiler is already clean and a native one searches all four. |
| `13/mangle-NIX_STORE-in-__FILE__.patch` | applied | `cc-wrapper` sets `useMacroPrefixMap = !isGNU`, and this set's `gcc` is `isGNU`, so nothing else keeps store paths out of `__FILE__`. |
| `cfi_startproc-reorder-label-14-1.diff` | applied, in `libgcc`, off Darwin | Needed on aarch64, and belongs to `libgcc` rather than `gcc`: it patches `libgcc/config/aarch64/lse.S`, whose output clang 18 and later refuse to assemble. Held back on Darwin, where the `iains` branch replaces `STARTFN` with an `ENTRY` macro that already writes the label ahead of `.cfi_startproc`. |
| `libstdc-fix-compilation-in-freestanding-win32.patch` | believed unnecessary | Only takes effect under `!_GLIBCXX_HOSTED`, and `libstdcxx` is built against a real libc here. The monolithic set needs it because its `withoutTargetLibc` stage builds a freestanding libstdc++. |
| the Darwin set (`iains` and Homebrew) | applied | Darwin is in scope; it is just not tested yet. Two of the three are `libgcc` patches rather than `gcc` ones, as `cfi_startproc` was: `libgcc-darwin-fix-reexport` (`libgcc/config/t-slibgcc-darwin`) and `libgcc-darwin-detection` (`libgcc/config.host`). The third, `gcc-16-darwin-aarch64-support`, spans the monorepo, so each package takes the files it builds -- `gcc`, `libgcc` and `libsanitizer` -- as `system-libbacktrace.patch` already is. `libitm` and `libgcobol` are not packaged here, so their three files are dropped. It also supersedes two of our own patches, which are held back on Darwin: `cfi_startproc-reorder-label` and `fix-collect2-paths`. |
| `c++tools-dont-check-enable-default-pie.patch` | applied, below 16 | `--enable-default-pie` is about the target, but `c++tools` is built for the host, so it should follow `--enable-host-pie` instead. We pass `--enable-default-pie` and we do build `c++tools` -- there is a `g++-mapper-server` in the output -- so the mis-scoped flag applies here too. Upstream only in 14 and 15, and 15 is the default here, so this does not go away soon. |
| `ppc-musl.patch` | applied | Needed on powerpc+musl, and `no-sys-dirs` does not subsume it: that one `#undef`s `LOCAL_INCLUDE_DIR` in `cppdefault.cc`, but `rs6000/sysv4.h` tests the macro earlier, where it builds `INCLUDE_DEFAULTS_MUSL_LOCAL`, so `/usr/local/include` survives there. |
| `gcc-12-gfortran-driving.patch` | applied, on `langFortran` | Needed wherever libtool parses `gfortran -v`, which `libgfortran` does. Gate it on `langFortran` as the monolithic set does. |
| the two Cygwin patches | applied, on `isCygwin` | Neither is upstream in 15 or 16. They belong with whatever enables Cygwin here rather than with this set's own bootstrap. |
| `libssp-noshared-musl32.patch` | undecided | Makes `LINK_SSP_SPEC` link `-lssp_nonshared` unconditionally, which is an Alpine assumption about what the libc ships, and this set builds its own `libssp`. Worth settling against a real musl x86_32 target rather than on paper. |

Everything the monolithic set has is now applied here, bar `libssp-noshared-musl32.patch`, which is undecided for the reason above.

None of the Darwin ones is tested: there is no Darwin machine here.
What is checked is that each component's list applies in order, with `patch(1)`, on a pristine tree, and that nothing off Darwin changes.
