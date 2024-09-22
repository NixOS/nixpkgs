{
  lib,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "ophis";
    version = "0-unstable-2019-04-13";

    src = fetchFromGitHub {
      owner = "michaelcmartin";
      repo = "Ophis";
      rev = "99f074da278d4ec80689c0e22e20c5552ea12512";
      hash = "sha256-2x8vwLTSngqQqmVrVh/mM4peATgaRqOSwrfm5XCkg/g=";
    };

    sourceRoot = "${self.src.name}/src";

    passthru = {
      updateScript = unstableGitUpdater { };
    };

    meta = {
      homepage = "http://michaelcmartin.github.io/Ophis/";
      description = "Cross-assembler for the 6502 series of microprocessors";
      longDescription = ''
        Ophis is an assembler for the 6502 microprocessor - the famous chip used
        in the vast majority of the classic 8-bit computers and consoles. Its
        primary design goals are code readability and output flexibility - Ophis
        has successfully been used to create programs for the Nintendo
        Entertainment System, the Atari 2600, and the Commodore 64.
      '';
      license = lib.licenses.mit;
      mainProgram = "ophis";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
self
