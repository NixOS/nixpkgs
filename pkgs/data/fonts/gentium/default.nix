{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "gentium-${version}";
  version = "1.504";

  src = fetchzip {
    name = "${name}.zip";
    url = "http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=GentiumPlus-${version}.zip&filename=${name}.zip";
    sha256 = "1xdx80dfal0b8rkrp1janybx2hki7algnvkx4hyghgikpjcjkdh7";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v FONTLOG.txt GENTIUM-FAQ.txt README.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = "http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=Gentium";
    description = "A high-quality typeface family for Latin, Cyrillic, and Greek";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
