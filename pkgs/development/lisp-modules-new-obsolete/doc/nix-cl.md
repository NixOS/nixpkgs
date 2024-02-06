## Use cases

This page lists some possible use cases for nix-cl.

## Pinning down the exact commits of libraries

Sometimes, a bug is fixed upstream but is not yet available in package
repositories such as Quicklisp or Ultralisp. The users have to wait
for the repository maintainer to update it, or download and compile
the patched sources themselves.

This is a manual and hard to reproduce process. By leveraging Nix,
users of `nix-cl` can essentially "run their own package repository",
written as Nix code, with all the benefits of that (shareability,
cacheability, reproducibility, version-controllable etc.)


## Modifying libraries with patches

Other times, a bug in a library is not fixed upstream, but you fixed
it yourself. Or, you would like a change to the internals that the
maintainers don't like.

Sure, you could fork the code or maintain patches manually, but that
becomes hard to manage with a lot of patches. It also doesn't have the
benefits mentioned in the previous section.

`nix-cl` provides a way of applying version-controlled patches to any
package.


## Using libraries not available in repositories

There are useful and working libraries out there, that are nonetheless
unavailable to users of package managers such as Quicklisp or
Ultralisp. Two real-world examples are [jzon] and [cl-tar].

`nix-cl` is not tied to any particular package source: instead,
packages are written as a Nix expression, which can be done manually
or generated/imported.

This frees the user to have any package they want, and not be
constrained by a central repository.

## Reproducible environments

The usual way to develop a project involves several steps, such as:

1. Installing a Lisp implementation
2. Installing a package manager
3. Installing the chosen libraries

This is not necessarily reproducible. It's unlikely to come back a
year later and develop the project using the exact same versions of
the dependencies.

Things can break between attempts at different points in time. The
repository could have updated versions in the meantime. The source
tarballs could become unreachable.

With `nix-cl` you can have your own binary cache for Lisp libraries
and not be affected by downtime of other central repositories.

## Testing across CL implementations

One can manually download different Lisp implementations and run tests
of a package. This works well in most cases, but it is limited in how
you can tweak the software. Some practical examples are:

- Statically compiling [zlib] into [SBCL]
- Building SBCL with the `--fancy` flag
- Compiling [ECL] as a static library

These are usually hard to do manually, unless you have the necessary
compilers already configured. These combinations are usually not
available from package managers as well.

With Nix it's easier, because it will set up the build environment
automatically. It could be useful to, for example:

- Test against all possible compiler flag combinations
- Libc versions (ECL)
- JDK versions ([ABCL])

[zlib]: https://zlib.net
[SBCL]: https://sbcl.org
[ECL]: https://ecl.common-lisp.dev/
[Ultralisp]: https://ultralisp.org/
[jzon]: https://github.com/Zulu-Inuoe/jzon
[cl-tar]: https://gitlab.common-lisp.net/cl-tar/cl-tar
[bootstrap tools]: https://github.com/NixOS/nixpkgs/tree/master/pkgs/stdenv/linux/bootstrap-files
[nixpkgs]: https://github.com/NixOS/nixpkgs

## Windows note

Note that all of this still only applies to Unix systems - primarily because Nix doesn't work on Windows.

If you have an idea how to port some of the functionality to Windows, get in touch.
