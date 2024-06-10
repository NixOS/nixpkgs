{ fetchFromGitHub, lib, stdenv, fontforge, perl, perlPackages }:

let
  version = "2.37";

  meta = {
    description = "Typeface family based on the Bitstream Vera fonts";
    longDescription = ''
      The DejaVu fonts are TrueType fonts based on the BitStream Vera fonts,
      providing more styles and with greater coverage of Unicode.

      This package includes DejaVu Sans, DejaVu Serif, DejaVu Sans Mono, and
      the TeX Gyre DejaVu Math font.
    '';
    homepage = "https://dejavu-fonts.github.io/";

    # Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved.
    # Copyright (c) 2006 by Tavmjong Bah. All Rights Reserved.
    # DejaVu changes are in public domain
    # See http://dejavu-fonts.org/wiki/License for details
    license = lib.licenses.free;

    platforms = lib.platforms.all;
  };

  full-ttf = stdenv.mkDerivation {
    pname = "dejavu-fonts-full";
    inherit version;
    nativeBuildInputs = [fontforge perl perlPackages.IOString perlPackages.FontTTF];

    src = fetchFromGitHub {
      owner = "dejavu-fonts";
      repo = "dejavu-fonts";
      rev = "version_${lib.replaceStrings ["."] ["_"] version}";
      sha256 = "1xknlg2h287dx34v2n5r33bpcl4biqf0cv7nak657rjki7s0k4bk";
    };

    buildFlags = [ "full-ttf" ];

    preBuild = "patchShebangs scripts";

    installPhase = "install -m444 -Dt $out/share/fonts/truetype build/*.ttf";

    inherit meta;
  };

  minimal = stdenv.mkDerivation {
    pname = "dejavu-fonts-minimal";
    inherit version;
    buildCommand = ''
      install -m444 -Dt $out/share/fonts/truetype ${full-ttf}/share/fonts/truetype/DejaVuSans.ttf
    '';
    inherit meta;
  };
in stdenv.mkDerivation {
  pname = "dejavu-fonts";
  inherit version;
  buildCommand = ''
    install -m444 -Dt $out/share/fonts/truetype ${full-ttf}/share/fonts/truetype/*.ttf
    ln -s --relative --force --target-directory=$out/share/fonts/truetype ${minimal}/share/fonts/truetype/DejaVuSans.ttf
  '';
  inherit meta;

  passthru = { inherit minimal full-ttf; };
}
