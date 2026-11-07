# Passagemath

[passagemath](https://github.com/passagemath/passagemath/tree/main) is a fork of [SageMath](https://github.com/sagemath/sage) that aims to be more modular.
Since it is modular, it may be easier to package than SageMath.


## Modular features instead of compile-time feature selection

In SageMath, there is a lot of compile time activable features depending on third-party libraries and executables, which result in an opionnated package definition.

`passagemath` fixes this by transforming these compile time features into python dependencies.
These additional features are listed here [in the passagemath README.md](https://github.com/passagemath/passagemath/tree/main#distributions-named-after-a-third-party-non-python-dependency)
If the user call a function requiring a particular native feature, it will result in a Python ImportError.

## Runtimes

Sometimes, giving native librairies during compilation time is not enough for a passagemath package to find its required executable/library.
To address this, Sage modules uses the `sage.env.var(MY_DEPENDENCY)` function to fetch variables in this order of fallback :
    1. Search inside the user's environment variables if `MY_DEPENDENCY` exists;
    2. Search inside the `sage.config`, if `sage.config.MY_DEPENDENCY` exists;
    3. Just return the fallback given by the calling Sage module, which is most likely a mix of searching through environment variables and common linux paths.

Fallback n°2 is great to keep the user environment clean and not have to modify his `mkShell` with environment variables.
It's the package manager's defined fallback.

It's also good to keep fallback n°1 clean if the user is trying some change some feature.

`passagemath-conf` (or `sage-conf`) is a dummy package that provides the `sage.config` module.
It is a an interface to be implemented by different package managers.
For instance, there are [Pypi](https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf_pypi) and [Conda](https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf_conda) implementation of this package.

In this PR, `passagemath-conf-nix` includes the Nix implementation of `passagemath-conf`.
Due to build requirements, it is not possible to change the name of this dependency since pyproject always search for a `passagemath-conf` dependency, and for `passagemath-conf-nix`.

### How it is implemented

When evaluated, `sage.config` takes the value of the `_sage_conf._conf` module.
`_sage_conf._conf` evaluates every modules in `_sage_conf/` (but itself), and merge the found attributes in itself:
```
sage_conf
├── pyproject.toml
├── README.rst
├── sage
│   ├── config.py # Imports _sage_conf
├── _sage_conf
│   ├── _conf.py
│   ├── __main__.py
│   ├── passagemath_runtime_gap.py      # from derivation 'python3Packages.passagemath-runtime-gap'
│   ├── passagemath_runtime_linbox.py   # from derivation 'python3Packages.passagemath-runtime-linbox'
│   └── ...
└── setup.py

```

This mean we can create mini packages defining no Sage features, but only runtime variables for sage package.
These runtime feature packages are named like so : `passagemath-runtime-<feature>`, and are defined using the `mkSageRuntimeConfig`
`passagemath-runtimes` is the package that aggregate every `passagemath-runtime-*`.

The passagemath-runtimes metapackage is included only at the final composition level in order to not retrigger builds on change.
Compiled PassageMath packages do not depend on these runtime configuration packages, so changing runtime configuration alone does not invalidate their builds.

**Security note:** Since the `passagemath-runtime-*` packages write real python code, it should be reviewed with care for future PRs, even though code injection is greatly reduced via `builtins.toJSON`.
[Here is the definition of `mkSageRuntimeConfig.](./mk-sage-runtime-config.nix)

## Cython include paths

PassageMath normally uses `sage_include_directories(use_sources=True)` to locate headers in the Sage source tree ([code here](./passagemath-setup/__init__.py#L172)).
However, Nix builds each PassageMath distribution separately, with dependencies installed in different Nix store paths. To support this modular layout, `passagemath-setup` is patched to also include directories from `sage_include_directories(use_sources=False)`, which discovers installed Sage namespace packages.
These paths are also passed to Cython's `include_path` so that `.pxd` files from other PassageMath distributions can be resolved during compilation.

## Sources from Pypi

Most of the sources uses fetchFromPypi.
As mentionned in the contribution guideline, fetchFromGitHub should be used when possible unless there is a good reason not to.
PassageMath is developed as a monorepo containing multiple Python distributions that share source files and build infrastructure.
Therefor, fetchFromPypi may be a better fit to fetch the precises components for each builds.


## Compilation

Compiling from `passagemath-conf-nix` up to `passagemath-standard` takes about an hour (for Python3.14 only)
The build as been tested for NixOS `x86_64-linux` with Python3.14, **without** free-threading.


## Downgrades

Passagemath packages requires some [downgraded packages](./downgrades).

## Usage example

```nix
# CTF Ready
python3.withPackages (pypkgs: [
    pypkgs.passagemath-standard
    pypkgs.cryptodome
    pypkgs.fpylll
    pypkgs.jupyter
    pypkgs.pwntools
]);
```

```nix
# Some modular install
python3.withPackages (pypkgs: [
    pypkgs.passagemath-modules
    pypkgs.passagemath-flint
    pypkgs.passagemath-runtime-flint
]);
```

