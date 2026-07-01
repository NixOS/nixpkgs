# Qt 5 Maintainer's Notes

## Minor Updates

Let `$major` be the major version number, e.g. `5.9`.

1. Change the version number in the `$major/fetch.sh`.
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/$major`
   from the top of the Nixpkgs tree.

See below if it is necessary to update any patches.

## Major Updates

Let `$major` be the new major version number, e.g. `5.10`.

1. Copy the subdirectory from the previous major version to `$major`.
2. Change the version number in `$major/fetch.sh`.
3. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/$major`
   from the top of the Nixpkgs tree.
4. Add a top-level attribute in `pkgs/top-level/all-packages.nix` for the new
   major version.
5. Change the `qt5` top-level attribute to point to the new major version.
6. If the previous major version is _not_ a long-term support release,
   remove it from Nixpkgs.

See below if it is necessary to update any patches.

## Patches

Nixpkgs maintains several patches for Qt which cannot be submitted upstream. To
facilitate maintenance, a fork of the upstream repository is created for each patched module:

- [qtbase](https://github.com/ttuegel/qtbase)
- [qtwebkit](https://github.com/ttuegel/qtwebkit)
- [qttools](https://github.com/ttuegel/qttools)
- [qtscript](https://github.com/ttuegel/qtscript)
- [qtserialport](https://github.com/ttuegel/qtserialport)
- [qtdeclarative](https://github.com/ttuegel/qtdeclarative)
- [qtwebengine](https://github.com/ttuegel/qtwebengine)

In each repository, the patches are contained in a branch named `nixpkgs/$major`
for each major version. Please make a pull request to add or update any patch
which will be maintained in Nixpkgs.

The forked repository for each module is used to create a single patch in
Nixpkgs. To recreate the patch for module `$module` (e.g. `qtbase`) at version
`$version` (e.g. `5.9.1`) in the branch `$major` (e.g. `5.9`),

1. Clone the fork for `$module` from the list above.
2. Checkout the active branch, `git checkout nixpkgs/$major`.
3. Compare the patched branch to the release tag,
   `git diff v$version > $module.patch`.
4. Copy `$module.patch` into the Nixpkgs tree.

### Minor Version Updates

To update module `$module` to version `$version` from an older version in the
same branch `$major`,

1. Clone the fork for `$module` from the list above.
2. Checkout the active branch, `git checkout nixpkgs/$major`.
3. Merge the new version into the active branch,
   `git merge --no-ff v$version`.
4. Fix any conflicts.
5. Open a pull request for the changes.
6. Follow the instructions above to recreate the module patch in Nixpkgs.

### Major Version Updates

To update module `$module` from `$oldversion` in branch `$oldmajor` to version
`$version` in branch `$major`,

1. Clone the fork for `$module` from the list above.
2. Checkout a new branch for the new major version,
   `git checkout -b nixpkgs/$major nixpkgs/$oldmajor`.
3. Rebase the patches from `$oldversion` onto the new branch,
   `git rebase v$oldversion --onto v$version`.
4. Fix any conflicts.
5. Open a pull request for the changes.
6. Follow the instructions above to recreate the module patch in Nixpkgs.
