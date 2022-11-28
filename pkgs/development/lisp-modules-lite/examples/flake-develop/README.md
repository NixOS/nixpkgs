# `nix develop` support for lispPackagesLite (flakes)

Copy this directory to another folder (including the `.envrc` file) and run:

```
nix develop
```

Don’t run that inside this nixpkgs folder, unless you like waiting.

If you have [direnv](https://direnv.net/) installed, just enter the directory
and it should automatically load it for you.

Now you can run SBCL with alexandria on the path:

```
sbcl --script <<EOF
(require :asdf)
(asdf:load-system :alexandria)
(print (alexandria:iota 3))
EOF
```

You could also for example run `emacs` from this shell to have access to SBCL from within it.
