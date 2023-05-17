{ lib
, stdenv
, unzip
, fetchurl
}:

let
  maple-font = { pname, sha256, desc }: stdenv.mkDerivation
    rec{

      inherit pname desc;
      version = "6.3";
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
        find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
        find . -name '*.woff2'  -exec install -Dt $out/share/fonts/woff2 {} \;
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
    sha256 = "sha256-Ap4OwP/QGFz9+xn12rekia1/pwRxZvv+H+ZmZiXcxcY=";
    desc = "monospace";
  };

  NF = maple-font {
    pname = "MapleMono-NF";
    sha256 = "sha256-WZHFQRG+81TF5YgOT249c8VA8vAvYowiQx/pqsDuJ4o=";
    desc = "Nerd Font";
  };

  SC-NF = maple-font {
    pname = "MapleMono-SC-NF";
    sha256 = "sha256-26odkmMljEwstRywDYJ7Dst5pfOXrtQTcrFFxbRwHcA=";
    desc = "Nerd Font SC";
  };

  opentype = maple-font {
    pname = "MapleMono-otf";
    sha256 = "sha256-u2IuymjiosoSbdIW7h2QalagTI+eDMRSuhLgXy5RdRA=";
    desc = "OpenType";
  };

  woff2 = maple-font {
    pname = "MapleMono-woff2";
    sha256 = "sha256-iv6Q/aYMlAkhaem8tFWAzqc9mVgWQXghBzcHJz1dg/Y=";
    desc = "WOFF2.0";
  };
}


