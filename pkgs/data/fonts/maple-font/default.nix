{ lib
, stdenv
, unzip
, fetchurl
}:

let
  maple-font = { pname, version, sha256, desc }: stdenv.mkDerivation
    rec{

      inherit pname version desc;
      src = fetchurl {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
        inherit sha256;
      };

      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      setSourceRoot = "sourceRoot=`pwd`";
      nativeBuildInputs = [ unzip ];
      installPhase = ''
        find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
      '';

      meta = with lib; {
        homepage = "https://github.com/subframe7536/Maple-font";
        description = ''
          Open source ${desc} font with round corner and ligatures for IDE and command line
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ oluceps ];
      };

    };
in
{
  Mono = maple-font {
    pname = "MapleMono";
    version = "6.1";
    sha256 = "sha256-JWyZH2F9lwWt9ROhuOtVf8HIjUAWkhCbXium0iNQry8=";
    desc = "monospace";
  };

  NF = maple-font {
    pname = "MapleMono-NF";
    version = "6.1";
    sha256 = "sha256-z0qoPMvowasHRK1IUMnx+lufUXqZkT3WBLtpEkP4V4I=";
    desc = "Nerd Font";
  };

  SC-NF = maple-font {
    pname = "MapleMono-SC-NF";
    version = "6.1";
    sha256 = "sha256-cp7pASXEiP8Td8yR+5hKpZyTST0o0pxgck4llHps4go=";
    desc = "Nerd Font SC";
  };

}


