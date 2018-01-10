{fetchFromGitHub, stdenv, fontforge, perl, FontTTF}:

let
  version = "2.37";

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

  full-ttf = stdenv.mkDerivation {
    name = "dejavu-fonts-full-${version}";
    buildInputs = [fontforge perl FontTTF];

    src = fetchFromGitHub {
      owner = "dejavu-fonts";
      repo = "dejavu-fonts";
      rev = "version_${stdenv.lib.replaceStrings ["."] ["_"] version}";
      sha256 = "1xknlg2h287dx34v2n5r33bpcl4biqf0cv7nak657rjki7s0k4bk";
    };

    buildFlags = "full-ttf";

    preBuild = "patchShebangs scripts";

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp build/*.ttf $out/share/fonts/truetype/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1cxprzsr826d888ha4zxx28i9jfj1k74q9kfv3v2rf603460iha9";
    inherit meta;
  };

  minimal = stdenv.mkDerivation {
    name = "dejavu-fonts-minimal-${version}";
    buildCommand = ''
      install -D ${full-ttf}/share/fonts/truetype/DejaVuSans.ttf $out/share/fonts/truetype/DejaVuSans.ttf
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0ybsynp9904vmd3qv5b438swhx43m5q6gfih3i32iw33rks8nkpj";
    inherit meta;
  };
in stdenv.mkDerivation {
  name = "dejavu-fonts-${version}";
  buildCommand = ''
    mkdir -p $out/share/fonts/truetype
    cp ${full-ttf}/share/fonts/truetype/*.ttf $out/share/fonts/truetype/
    ln -s --relative --force --target-directory=$out/share/fonts/truetype ${minimal}/share/fonts/truetype/DejaVuSans.ttf
  '';
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "15l93xm9mg2ziaxv4nqy2a4jaz54d05xf0hfz1h84bclzb882llh";
  inherit meta;

  passthru.minimal = minimal;
}
