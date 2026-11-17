This is the Swift package set (assembled in `pkgs/top-level/swift-packages.nix`).  It contains mainly the packages
needed to build the Swift toolchain. See the Swift documentation for how to work with Swift in nixpkgs.

# Updating the package set

Run the `update.sh` script to update the package set. It will update all hashes (including SwiftPM and NPM deps hashes).
Packages that are not toolchain packages have update scripts and should (hopefully) have PRs opened automatically by the
update bot to update them. They try to follow semver, so minor and patch updates should be safe. Major updates may
require patching or migration work to make work with the toolchain. We want to follow the latest version when possible.

After the update script is run, your next task is updating the patches. Use `git am` to apply the patches to the tag
to the new version and fix any conflicts that happen. If a package is used by the bootstrap compiler, and you need to
update patches, use `patchesForVersion` if it’s not being used already to use different patches for each version.

Note: You’ll have to determine the versions of swift-docc-render and swift-tools-protocols manually.
