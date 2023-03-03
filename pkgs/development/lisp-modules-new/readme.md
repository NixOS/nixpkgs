# lisp-modules

Utilities for packaging ASDF systems using Nix.

## Quick start

#### Build an ASDF system:

```
nix-build ./examples/bordeaux-threads.nix
ls result/src
```

#### Build an `sbclWithPackages`:

```
nix-build ./examples/sbcl-with-bt.nix
result/bin/sbcl
```

#### Re-import Quicklisp packages:

```
nix-shell --run 'sbcl --script ql-import.lisp'
```

#### Test build of packages
```
(cd test;  sbcl --script test.lisp ccl)
```

## Documentation

See `doc` directory.
