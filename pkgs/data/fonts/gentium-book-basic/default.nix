{ stdenv, fetchzip }:

let
  major = "1";
  minor = "102";
  version = "${major}.${minor}";
in fetchzip rec {
  name = "gentium-book-basic-${version}";

  url = "http://software.sil.org/downloads/r/gentium/GentiumBasic_${major}${minor}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -l $downloadedFile
    unzip -j $downloadedFile \*.ttf                            -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*/FONTLOG.txt \*/GENTIUM-FAQ.txt -d $out/share/doc/${name}
  '';

  sha256 = "0598zr5f7d6ll48pbfbmmkrybhhdks9b2g3m2g67wm40070ffzmd";

  meta = with stdenv.lib; {
    homepage = http://software.sil.org/gentium/;
    description = "A high-quality typeface family for Latin, Cyrillic, and Greek";
    maintainers = with maintainers; [ ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
