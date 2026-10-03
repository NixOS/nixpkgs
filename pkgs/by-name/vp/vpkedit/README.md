# VPKEdit

## Generating Dependencies List

This package uses a helper script ([generate-deps.py](./generate-deps.py)) to generate its dependencies list. The script runs CMake to generate the build files and captures `stdout` to generate a list of all `FetchContent` calls, both making them into nix `fetchgit` functions and adding them to `cmakeFlags` as `cmakeFeatures`, which it then prints to `stdout`.

Inside [generate-deps.py](./generate-deps.py) is a comment explaining how to manually add dependencies to it if it isn't picking them up automatically.

### Example

```sh
nix develop .#vpkedit
nix shell nixpkgs#{nix-prefetch-git,git,python3}
git clone --recurse-submodules --branch ${tag} https://github.com/craftablescience/VPKEdit.git
cd VPKEdit
python ../generate-deps.py -n --args -DCPACK_GENERATOR=DEB -DCMAKE_BUILD_TYPE=Release
```
