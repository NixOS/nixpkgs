{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "gentium-${version}";
  version = "5.000";

  src = fetchzip {
    url = "http://software.sil.org/downloads/d/gentium/GentiumPlus-${version}.zip";
    sha256 = "0g9sx38wh7f0m16gr64g2xggjwak2q6jw9y4zhrvhmp4aq4xfqm6";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -vr documentation/ FONTLOG.txt GENTIUM-FAQ.txt README.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://software.sil.org/gentium/;
    description = "A high-quality typeface family for Latin, Cyrillic, and Greek";
    longDescription = ''
      Gentium is a typeface family designed to enable the diverse ethnic groups
      around the world who use the Latin, Cyrillic and Greek scripts to produce
      readable, high-quality publications. It supports a wide range of Latin and
      Cyrillic-based alphabets.

      The design is intended to be highly readable, reasonably compact, and
      visually attractive. The additional ‘extended’ Latin letters are designed
      to naturally harmonize with the traditional 26 ones. Diacritics are
      treated with careful thought and attention to their use. Gentium Plus also
      supports both polytonic and monotonic Greek.

      This package contains the regular and italic styles for the Gentium Plus
      font family, along with documentation.
    '';
    downloadPage = "http://software.sil.org/gentium/download/";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
