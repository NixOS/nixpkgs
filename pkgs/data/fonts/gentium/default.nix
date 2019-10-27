{ lib, fetchzip }:

let
  version = "5.000";
in fetchzip rec {
  name = "gentium-${version}";

  url = "http://software.sil.org/downloads/r/gentium/GentiumPlus-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -l $downloadedFile
    unzip -j $downloadedFile \*.ttf                                          -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*/FONTLOG.txt \*/GENTIUM-FAQ.txt \*/README.txt -d $out/share/doc/${name}
    unzip -j $downloadedFile \*/documentation/\*                             -d $out/share/doc/${name}/documentation
  '';

  sha256 = "1qr2wjdmm93167b0w9cidlf3wwsyjx4838ja9jmm4jkyian5whhp";

  meta = with lib; {
    homepage = https://software.sil.org/gentium/;
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
    downloadPage = "https://software.sil.org/gentium/download/";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
