{ lib
, stdenv
, unzip
, fetchurl
}:

let
  maple-font = { pname, sha256, desc }: stdenv.mkDerivation
    rec{

      inherit pname desc;
      version = "6.2";
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
    sha256 = "sha256-KhG0gQRnHFvpoxdcySSEYWDtOgG4xIm8X0Ua9o1aGTw=";
    desc = "monospace";
  };

  NF = maple-font {
    pname = "MapleMono-NF";
    sha256 = "sha256-Ov6AEaLy80cwrFtmKWUceI809SwBlHsQf2F86/sc/6A=";
    desc = "Nerd Font";
  };

  SC-NF = maple-font {
    pname = "MapleMono-SC-NF";
    sha256 = "sha256-bb62YGzdE9qvlyuZG7YI16gOxWC+AijlRLY8ET+q5Rg=";
    desc = "Nerd Font SC";
  };

}


