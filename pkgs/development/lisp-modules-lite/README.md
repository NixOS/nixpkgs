# Nix Packages Lite

Nix-only implementation of a lispDerivation builder.

Called Lite because it’s relatively low complexity (LoC and layers of indirection) compared to the other two lisp module implementations.

## Features

(or anti features, depending on your POV)

- No QuickLisp
- No pre-build step to check-in .nix code: the .nix you see is everything you need
- All packages are independently tracked, loaded from authoritative source, and can (must!) be independently updated
- Supports multi-system source repositories (e.g. cl-async exports cl-async, cl-async-ssl, cl-async-repl) with different dependencies
- Fully relies ASDFv3 for finding systems: no path or system name rewriting
- Leaves source repositories intact: no .asd file mangling
- Automatic dependency resolution of all lisp modules
- Automatic “deduplication” of lisp modules in dependency graph (i.e. any source derivation is only ever included once, and all systems for which it’s being loaded are passed in that one single call)
- Very slow

## TODO

- More examples
- More packages (sub-todo: specify which packages are must-haves)
- Document the API (lispDerivation and lispMultiDerivation)
- Document how to overwrite a package
- Don’t use `CL_SOURCE_REGISTRY` but use source map files?
- Don’t clobber existing `CL_SOURCE_REGISTRY`
- Don't clobber existing `buildPhase` etc.
- Complete the list of "standard mkDerivation args" (dontUnpack, ...)
- Other lisps (currently hard-coded to SBCL)

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
