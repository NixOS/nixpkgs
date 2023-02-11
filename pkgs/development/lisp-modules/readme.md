# nix-cl

Utilities for packaging ASDF systems using Nix.

## Quick start

#### Run a lisp with packages:

```
$ nix-shell -p 'sbcl.withPackages (ps: with ps; [ alexandria bordeaux-threads ])'
$ sbcl

* (load (sb-ext:posix-getenv "ASDF"))
* (asdf:load-system 'alexandria)
```

Other lisps: ABCL, CCL, CLISP, ECL

#### Re-import Quicklisp packages:

```
nix-shell
sbcl --script ql-import.lisp
```


