## The API

This page documents the Nix API of nix-cl.

## Overview

The core API functions are `build-asdf-system` and
`lispWithPackagesInternal`.

They are considered more low-level that the rest of the API, which
builds on top of them to provide a more convenient interface with sane
defaults.

The higher-level API provides a lot of pre-configured packages,
including all of Quicklisp, and consists of the functions:

- `lispPackagesFor`
- `lispWithPackages`

Finally, there are functions that provide pre-defined Lisps, for
people who don't need to customize that:

- `abclPackages`, `eclPackages`, `cclPackages`, `claspPackages`, `sbclPackages`
- `abclWithPackages`, `eclWithPackages`, `cclWithPackages`, `claspWithPackages`, `sbclWithPackages`

The following is an attempt to document all of this.

## Packaging systems - `build-asdf-system`

Packages are declared using `build-asdf-system`. This function takes
the following arguments and returns a `derivation`.

#### Required arguments

##### `pname`
Name of the package/library

##### `version`
Version of the package/library

##### `src`
Source of the package/library (`fetchzip`, `fetchgit`, `fetchhg` etc.)

##### `lisp`
This command must load the provided file (`$buildScript`) then exit
immediately. For example, SBCL's --script flag does just that.

#### Optional arguments

##### `patches ? []`

Patches to apply to the source code before compiling it. This is a
list of files.

##### `nativeLibs ? []`

Native libraries, will be appended to the library
path. (`pkgs.openssl` etc.)

##### `javaLibs ? []`

Java libraries for ABCL, will be appended to the class path.

##### `lispLibs ? []`

Lisp dependencies These must themselves be packages built with
`build-asdf-system`

##### `systems ? [ pname ]`

Some libraries have multiple systems under one project, for example,
[cffi] has `cffi-grovel`, `cffi-toolchain` etc.  By default, only the
`pname` system is build.

`.asd's` not listed in `systems` are removed before saving the library
to the Nix store. This prevents ASDF from referring to uncompiled
systems on run time.

Also useful when the `pname` is differrent than the system name, such
as when using [reverse domain naming]. (see `jzon` ->
`com.inuoe.jzon`)

[cffi]: https://cffi.common-lisp.dev/
[reverse domain naming]: https://en.wikipedia.org/wiki/Reverse_domain_name_notation

##### `asds ? systems`

The .asd files that this package provides. By default, same as
`systems`.

#### Return value

A `derivation` that, when built, contains the sources and pre-compiled
FASL files (Lisp implementation dependent) alongside any other
artifacts generated during compilation.

#### Example

[bordeaux-threads.nix] contains a simple example of packaging
`alexandria` and `bordeaux-threads`.

[bordeaux-threads.nix]: /examples/bordeaux-threads.nix

## Building a Lisp with packages: `lispWithPackagesInternal`

Generators of Lisps configured to be able to `asdf:load-system`
pre-compiled libraries on run-time are built with
`lispWithPackagesInternal`.

#### Required Arguments

##### `clpkgs`

An attribute set of `derivation`s returned by `build-asdf-system`

#### Return value

`lispWithPackagesInternal` returns a function that takes one argument:
a function `(lambda (clpkgs) packages)`, that, given a set of
packages, returns a list of package `derivation`s to be included in
the closure.

#### Example

The [sbcl-with-bt.nix] example creates a runnable Lisp where the
`bordeaux-threads` defined in the previous section is precompiled and
loadable via `asdf:load-system`:

[sbcl-with-bt.nix]: /examples/sbcl-with-bt.nix

## Reusing pre-packaged Lisp libraries: `lispPackagesFor`

`lispPackagesFor` is a higher level version of
`lispPackagesForInternal`: it only takes one argument - a Lisp command
to use for compiling packages. It then provides a bunch of ready to
use packages.

#### Required Arguments

##### `lisp`

The Lisp command to use in calls to `build-asdf-system` while building
the library-provided Lisp package declarations.

#### Return value

A set of packages built with `build-asdf-system`.

#### Example

The [abcl-package-set.nix] example generates a set of thousands of packages for ABCL.

[abcl-package-set.nix]: /examples/abcl-package-set.nix

## Reusing pre-packaged Lisp libraries, part 2: `lispWithPackages`

This is simply a helper function to avoid having to call
`lispPackagesFor` if all you want is a Lisp-with-packages wrapper.

#### Required Arguments

##### `lisp`

The Lisp command to pass to `lispPackagesFor` in order for it to
generate a package set. That set is then passed to
`lispWithPackagesInternal`.

#### Return value

A Lisp-with-packages function (see sections above).

#### Example

The [abcl-with-packages.nix] example creates an `abclWithPackages` function.

[abcl-with-packages.nix]: /examples/abcl-with-packages.nix

## Using the default Lisp implementations

This is the easiest way to get going with `nix-cl` in general. Choose
the CL implementation of interest and a set of libraries, and get a
lisp-with-packages wrapper with those libraries pre-compiled.

#### `abclPackages`, `eclPackages`, `cclPackages`, `claspPackages`, `sbclPackages`

Ready to use package sets.

#### `abclWithPackages`, `eclWithPackages`, `cclWithPackages`, `claspWithPackages`, `sbclWithPackages`

Ready to use wrapper generators.

#### Example

For example, to open a shell with SBCL + hunchentoot + sqlite in PATH:
```
nix-shell -p 'with import ./. {}; sbclWithPackages (ps: [ ps.hunchentoot ps.sqlite ])'
```
