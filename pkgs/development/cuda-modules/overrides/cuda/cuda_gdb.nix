{
  cudaAtLeast,
  cudaMajorMinorVersion,
  gmp,
  lib,
  libxcrypt-legacy,
  ncurses,
  pkgs,
}:
let
  inherit (lib.attrsets)
    attrNames
    attrValues
    filterAttrs
    genAttrs
    recursiveUpdate
    ;
  inherit (lib.lists) map optionals range;
  inherit (lib.strings) optionalString;

  # desiredPython3MinorVersions :: List String
  desiredPython3MinorVersions =
    if cudaMajorMinorVersion == "12.5" then map builtins.toString (range 8 12) else [ ];

  # python3MinorVersionToPackage :: AttrSet (null | Package)
  python3MinorVersionToPackage = genAttrs desiredPython3MinorVersions (
    minorVersion: pkgs."python3${minorVersion}" or null
  );

  # python3Available :: AttrSet Package
  python3Available = filterAttrs (
    minorVersion: available: available != null
  ) python3MinorVersionToPackage;

  # python3Unavailable :: AttrSet null
  python3Unavailable = filterAttrs (
    minorVersion: available: available == null
  ) python3MinorVersionToPackage;

  additionalBuildInputs =
    # x86_64 only needs gmp from 12.0 and on
    optionals (cudaAtLeast "12.0") [ gmp ]
    # From 12.5, cuda-gdb comes with Python TUI wrappers
    ++ optionals (cudaAtLeast "12.5") (
      [
        libxcrypt-legacy
        ncurses
      ]
      ++ attrValues python3Available
    );

  additionalPostInstall =
    # Remove binaries requiring Python3 versions we do not have
    optionalString (cudaAtLeast "12.5") ''
      for minorVersion in ${builtins.concatStringsSep " " (attrNames python3Unavailable)}; do
        rm -f "''${!outputBin}/bin/cuda-gdb-python3.$minorVersion-tui"
      done
    '';
in
prevAttrs: {
  allowFHSReferences = true;

  brokenConditions = prevAttrs.brokenConditions // {
    "None of the desired Python3 versions are available" =
      desiredPython3MinorVersions != [ ] && python3Available == { };
  };

  buildInputs = prevAttrs.buildInputs ++ additionalBuildInputs;

  postInstall = (prevAttrs.postInstall or "") + additionalPostInstall;

  passthru = recursiveUpdate (prevAttrs.passthru or { }) {
    # Expose our fixes to the outside world so the cudatoolkit runfile installer can make use of them.
    fixups.cudatoolkit-legacy-runfile = {
      buildInputs = additionalBuildInputs;
      postInstall = additionalPostInstall;
    };
  };
}
