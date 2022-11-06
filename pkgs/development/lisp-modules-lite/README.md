# Nix Packages Lite

Nix-only implementation of a lispDerivation builder.

Called Lite because it’s relatively low complexity (LoC and layers of indirection) compared to the other two lisp module implementations.

## Features

(or anti features, depending on your POV)

- No QuickLisp
- No pre-build step to check-in .nix code: the .nix you see is everything you need
- All packages are independently tracked, loaded from authoritative source, and can be independently updated
- Supports multi-system source repositories (e.g. cl-async exports cl-async, cl-async-ssl, cl-async-repl) with different dependencies
- Fully relies ASDFv3 for finding systems: no path or system name rewriting
- Leaves source repositories intact: no .asd file mangling
- Automatic dependency resolution of all lisp modules
- Automatic “deduplication” of lisp modules in dependency graph (i.e. any source derivation is only ever included once, and all systems for which it’s being loaded are passed in that one single call)
- Very slow

## TODO

- Examples
- More packages (sub-todo: specify which packages are must-haves)
- Document the API (lispDerivation and lispMultiDerivation)
- Document how to overwrite a package
- Don’t use `CL_SOURCE_REGISTRY` but use source map files?
