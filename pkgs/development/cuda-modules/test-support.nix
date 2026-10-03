{
  buildPackages,
  lib,
  extraPath ? [ ],
}:
''
  # Installed interfaces must work without stdenv's flags or setup hooks.
  runStandalone() {
    env -i HOME="$TMPDIR" TMPDIR="$TMPDIR" \
      PATH=${
        lib.makeBinPath (
          [
            buildPackages.coreutils
            buildPackages.bash
          ]
          ++ extraPath
        )
      } \
      "$@"
  }
''
