{fetchurl, fetchFromGitHub, stdenv, fontforge, perl, fontconfig, FontTTF}:

let version = "2.37" ; in

stdenv.mkDerivation rec {
  name = "dejavu-fonts-${version}";
  #fontconfig is needed only for fc-lang (?)
  buildInputs = [fontforge perl FontTTF];

  unicodeData = fetchurl {
    url = http://www.unicode.org/Public/9.0.0/ucd/UnicodeData.txt ;
    sha256 = "13zfannnr6sa6s27ggvcvzmh133ndi38pfyxsssvjmw2s8ac9pv8";
  };
  blocks = fetchurl {
    url = http://www.unicode.org/Public/9.0.0/ucd/Blocks.txt;
    sha256 = "04xyws1prlcnqsryq56sm25dlfvr3464lbjjh9fyaclhi3a2f8b1";
  };

  src = fetchFromGitHub {
    owner = "dejavu-fonts";
    repo = "dejavu-fonts";
    rev = "version_${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1xknlg2h287dx34v2n5r33bpcl4biqf0cv7nak657rjki7s0k4bk";
  };

  buildFlags = "full-ttf";

  preBuild = ''
    sed -e s@/usr/bin/env@$(type -tP env)@ -i scripts/*
    sed -e s@/usr/bin/perl@$(type -tP perl)@ -i scripts/*
    mkdir resources
    tar xf ${fontconfig.src} --wildcards '*/fc-lang'
    ln -s $PWD/fontconfig-*/fc-lang -t resources/
    ln -s ${unicodeData} resources/UnicodeData.txt
    ln -s ${blocks} resources/Blocks.txt
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    for i in $(find build -name '*.ttf'); do
        cp $i $out/share/fonts/truetype;
    done;
  '';

  meta = {
    description = "A typeface family based on the Bitstream Vera fonts";
    longDescription = ''
      The DejaVu fonts are TrueType fonts based on the BitStream Vera fonts,
      providing more styles and with greater coverage of Unicode.

      This package includes DejaVu Sans, DejaVu Serif, DejaVu Sans Mono, and
      the TeX Gyre DejaVu Math font.
    '';
    homepage = http://dejavu-fonts.org/wiki/Main_Page;

    # Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved.
    # Copyright (c) 2006 by Tavmjong Bah. All Rights Reserved.
    # DejaVu changes are in public domain
    # See http://dejavu-fonts.org/wiki/License for details
    license = stdenv.lib.licenses.free;

    platforms = stdenv.lib.platforms.linux;
  };
}
