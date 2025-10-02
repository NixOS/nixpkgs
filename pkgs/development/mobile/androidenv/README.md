# How to update

`nix-shell maintainers/scripts/update.nix  --argstr package androidenv.test-suite --argstr commit true`

# How to run tests

You may need to make yourself familiar with [package tests](../../../README.md#package-tests) and [Writing larger package tests](../../../README.md#writing-larger-package-tests), then run tests locally with:

```shell
$ export NIXPKGS_ALLOW_UNFREE=1
$ cd path/to/nixpkgs
$ nix-build -A androidenv.test-suite
```
