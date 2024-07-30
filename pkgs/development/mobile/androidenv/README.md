# How to update

1. `./fetchrepo.sh`
2. `./mkrepo.sh`
3. Check the `repo.json` diff for new stable versions of `tools`, `platform-tools`, `build-tools`, `emulator` and/or `ndk`
4. Update the relevant argument defaults in `compose-android-packages.nix`

# How to run tests
You may need to make yourself familiar with [package tests](../../../README.md#package-tests), and [Writing larger package tests](../../../README.md#writing-larger-package-tests), then run tests locally with:

```shell
$ export NIXPKGS_ALLOW_UNFREE=1
$ cd path/to/nixpkgs
$ nix-build -A androidenv.test-suite.tests
```
