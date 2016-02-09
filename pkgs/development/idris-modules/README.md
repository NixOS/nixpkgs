Idris packages
==============

This directory contains build rules for idris packages. In addition,
it contains several functions to build and compose those packages.
Everything is exposed to the user via the `idrisPackages` attribute.

callPackage
------------

This is like the normal nixpkgs callPackage function, specialized to
idris packages.

builtins
---------

This is a list of all of the libraries that come packaged with Idris
itself.

build-idris-package
--------------------

A function to build an idris package. Its sole argument is a set like
you might pass to `stdenv.mkDerivation`, except `build-idris-package`
sets several attributes for you. See `build-idris-package.nix` for
details.

build-builtin-package
----------------------

A version of `build-idris-package` specialized to builtin libraries.
Mostly for internal use.

with-packages
-------------

Bundle idris together with a list of packages. Because idris currently
only supports a single directory in its library path, you must include
all desired libraries here, including `prelude` and `base`.