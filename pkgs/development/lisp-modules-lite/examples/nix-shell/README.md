# nix-shell support for lispPackagesLite

Enter this directory and run:

```
nix-shell
```

If you have [direnv](https://direnv.net/) installed, just enter the directory
and it should automatically load it for you.

Now you can run SBCL with arrow-macros on the ASDF path, plus all its dependencies (which includes Alexandria):

```
sbcl --script <<EOF
(require :asdf)
(asdf:load-system :alexandria)
(print (alexandria:iota 3))
EOF
```

You could also for example run `emacs` from this shell to have access to SBCL from within it.
