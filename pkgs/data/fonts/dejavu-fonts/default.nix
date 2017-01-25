{fetchFromGitHub, stdenv, fontforge, perl, FontTTF}:

let version = "2.37" ; in

stdenv.mkDerivation rec {
  name = "dejavu-fonts-${version}";
  buildInputs = [fontforge perl FontTTF];

  src = fetchFromGitHub {
    owner = "dejavu-fonts";
    repo = "dejavu-fonts";
    rev = "version_${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1xknlg2h287dx34v2n5r33bpcl4biqf0cv7nak657rjki7s0k4bk";
  };

  outputs = [ "out" "minimal" ];

  buildFlags = "full-ttf";

  preBuild = "patchShebangs scripts";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    for i in $(find build -name '*.ttf'); do
        cp $i $out/share/fonts/truetype;
    done;
  '' + ''
    local fname=share/fonts/truetype/DejaVuSans.ttf
    moveToOutput "$fname" "$minimal"
    ln -s "$minimal/$fname" "$out/$fname"
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

    platforms = stdenv.lib.platforms.unix;
  };
}
