# nix-cl

Utilities for packaging ASDF systems using Nix.

## Warning
This library is **EXPERIMENTAL** and everything can change

## Quick start

#### Build an ASDF system:

```
nix-build -E 'with import ./. {}; sbclPackages.bordeaux-threads'
ls result/src
```

#### Build an `sbclWithPackages`:

```
nix-build -E 'with import ./. {}; sbclWithPackages (p: [ p.hunchentoot p.sqlite ])'
result/bin/sbcl
```

#### Re-import Quicklisp packages:

```
nix-shell --run 'sbcl --script ql-import.lisp'
```

## Documentation

See `doc` directory.

## Other Nix+CL projects

- [ql2nix](https://github.com/SquircleSpace/ql2nix)
- [lisp-modules](https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/lisp-modules)
- [ql2nix](https://github.com/jasom/ql2nix)
- [cl2nix](https://github.com/teu5us/cl2nix)
- [clnix](https://git.sr.ht/~remexre/clnix)

## License

FreeBSD - see COPYING
