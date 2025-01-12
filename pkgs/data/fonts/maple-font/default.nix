{
  lib,
  stdenv,
  unzip,
  fetchurl,
}:

let
  maple-font =
    {
      pname,
      sha256,
      desc,
    }:
    stdenv.mkDerivation rec {
      inherit pname;
      version = "6.4";
      src = fetchurl {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
        inherit sha256;
      };

      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      sourceRoot = ".";
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
    pname = "MapleMono-ttf";
    sha256 = "sha256-a06JLIP5aVb9SeEz6kw+LqKy0ydCgaUlPDFWA2Y0G8Q=";
    desc = "monospace TrueType";
  };

  NF = maple-font {
    pname = "MapleMono-NF";
    sha256 = "sha256-fy+hdUYZDW5nkMVirhkmys3tIkWezPDrlpNxnRMl4WU=";
    desc = "Nerd Font";
  };

  SC-NF = maple-font {
    pname = "MapleMono-SC-NF";
    sha256 = "sha256-SbXWkrpLJUrq+Jt1h3GBP9md5TbYpPchdiR0oEDMAgY=";
    desc = "Nerd Font SC";
  };

  opentype = maple-font {
    pname = "MapleMono-otf";
    sha256 = "sha256-fwfFlNbaWXFCjcno7NK3dZqAzsHLh9rdGkSq26xc9qw=";
    desc = "OpenType";
  };

  woff2 = maple-font {
    pname = "MapleMono-woff2";
    sha256 = "sha256-4akpZGGth4yZjI5wjO3ZXrXcWNxb7/6YChU7T5fNVKs=";
    desc = "WOFF2.0";
  };

  autohint = maple-font {
    pname = "MapleMono-ttf-autohint";
    sha256 = "sha256-rSYIC42Bt+KFgxhwRhXS4sbh4etKYkCOo5nP2J2BHt4=";
    desc = "ttf autohint";
  };
}
