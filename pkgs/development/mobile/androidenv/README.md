# How to update

1. `./fetchrepo.sh`
2. `./mkrepo.sh`
3. Check the `repo.json` diff for new stable versions of `tools`, `platform-tools`, `build-tools`, `emulator` and/or `ndk`
4. Update the relevant argument defaults in `compose-android-packages.nix`
