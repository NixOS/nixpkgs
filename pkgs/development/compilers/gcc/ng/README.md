# GCC Next-Generation

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
