# PassageMath

[PassageMath](https://github.com/passagemath/passagemath/tree/main) is a fork of [SageMath](https://github.com/sagemath/sage) that aims to be more modular.
Since it is modular, it may be easier to package than SageMath.

## Most important information

- The most important package in this PR is `passagemath-conf-nix`. It is discussed in the "Runtimes" section.
- This PR may not be intended for direct inclusion in `nixpkgs`. It is more of a proof of concept for a more modular SageMath installation within nixpkgs.

## Modular features instead of compile-time feature selection

In SageMath, many features that depend on third-party libraries and executables can be enabled at compile time, resulting in many possible build outputs.

PassageMath addresses this by transforming these compile-time features into Python dependencies.
These features are listed in the [PassageMath README.md](https://github.com/passagemath/passagemath/tree/main#distributions-named-after-a-third-party-non-python-dependency).
If the user calls a function requiring a missing native feature, it will result in a Python error.

PassageMath splits the Sage library into separate distributions that share the `sage` namespace, each contributing its own modules and functionality.

## Runtimes

Sometimes, providing native libraries at compile time is not enough for a PassageMath package to locate its required executables or libraries at runtime.
To address this, Sage modules use the `sage.env.var(MY_DEPENDENCY)` function, provided by `passagemath-environment`, to look up configuration values in the following order:

1. Use the value of the user's `MY_DEPENDENCY` environment variable if it is set.
2. Use `sage.config.MY_DEPENDENCY` if it exists.
3. Return the fallback provided by the calling Sage module, which typically relies on environment variables and common Linux paths.

The second fallback keeps the user's environment clean and avoids requiring additional environment variables in their `mkShell`.
It is the fallback defined by the package manager.

Keeping configuration out of the user's environment also leaves the first option available for users who want to experiment with a feature.

`passagemath-conf` (or `sage-conf`) is a virtual package that provides the `sage.config` module.
It is an interface that different package managers can implement.
For instance, there are [PyPI](https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf_pypi) and [conda](https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf_conda) implementations of this package.

In this PR, `passagemath-conf-nix/default.nix` contains the Nix implementation of `passagemath-conf`.
Its package name is `passagemath-conf`.
We may rename its directory to `passagemath-conf` if required by the guidelines.

### How it is implemented

When imported, `sage.config` imports configuration values from the `_sage_conf._conf` module.
`_sage_conf._conf` imports every module in `_sage_conf/` matching `passagemath_runtime_*` and merges the collected attributes into its own namespace:

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

This means we can create small packages that define only runtime variables for Sage packages, without providing Sage features.
These runtime configuration packages are named `passagemath-runtime-<feature>` and are defined using the `mkSageRuntimeConfig` helper.
`passagemath-runtimes` is the package that aggregates all `passagemath-runtime-*` packages.

The `passagemath-runtimes` metapackage is included only at the final composition level to avoid triggering rebuilds when runtime configuration changes.
Compiled PassageMath packages do not depend on these runtime configuration packages, so changing runtime configuration alone does not invalidate their builds.

**Security note:** Since the `passagemath-runtime-*` packages generate Python code, this code should be reviewed carefully in future PRs, even though the risk of code injection is greatly reduced by `builtins.toJSON`.
[Here is the definition of `mkSageRuntimeConfig`.](./mk-sage-runtime-config.nix)

## Cython include paths

PassageMath normally uses `sage_include_directories(use_sources=True)` to locate headers in the Sage source tree ([code here](./passagemath-setup/__init__.py#L172)).
However, Nix builds each PassageMath distribution separately, with dependencies installed in different Nix store paths. To support this modular layout, `passagemath-setup` is patched to also include directories from `sage_include_directories(use_sources=False)`, which discovers installed Sage namespace packages.
These paths are also passed to Cython's `include_path` so that `.pxd` files from other PassageMath distributions can be resolved during compilation.

Using a patch file may be cleaner.

## Sources from PyPI

Most packages fetch their sources using `fetchPypi`.
As mentioned in the contribution guidelines, `fetchFromGitHub` should be used when possible unless there is a good reason not to.
PassageMath is developed as a monorepo containing multiple Python distributions that share source files and build infrastructure.
Therefore, `fetchPypi` may be a better fit for fetching the specific components needed for each build.


## Compilation

Compiling from `passagemath-conf-nix` up to `passagemath-standard` takes about an hour (for Python 3.14 only).
The build has been tested natively with the following configuration:

- Build platform: `x86_64-linux`, NixOS
- Host platform: `x86_64-linux`, NixOS
- Python interpreter: `CPython 3.14.8`, **without free-threading**


## Downgrades

PassageMath packages require some [downgraded packages](./downgrades).

Currently, three packages are downgraded:

- `memory-allocator`: a Python package from SageMath already present in `nixpkgs`
- `mpmath`: a Python package
- `primecount`: a native library

Native libraries are less problematic to downgrade.
Python packages, on the other hand, can lead to inconsistent Python environments, which can cause runtime errors.

In practice, only `mpmath` is a problem, since the `memory-allocator` package is only used by SageMath and PassageMath, to my knowledge.

- `passagemath-symbolics` and `passagemath-modules`, as well as all packages depending on either of them (such as `passagemath-standard`), require the downgraded version of `mpmath`.
- The default nixpkgs `sympy` package depends on the default nixpkgs version of `mpmath`.

Mixing these PassageMath packages with the default nixpkgs `mpmath` or `sympy` introduces conflicting package variants.

`passagemath-symbolics` also depends on a version of `sympy` rebuilt with the downgraded `mpmath`.

## Usage example

The `passagemath-*` packages are Python packages, so you can use them alongside your other installed Python packages.

```nix
# CTF Ready
python3.withPackages (pypkgs: [
  pypkgs.passagemath-standard
  pypkgs.pycryptodome
  pypkgs.fpylll # is a dependency of passagemath-standard anyway
  pypkgs.jupyter
  pypkgs.pwntools
])
```

## AI usage

- Most package definition skeletons where AI genrated.
- Some git commits

