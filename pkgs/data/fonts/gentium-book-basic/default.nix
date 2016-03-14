{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "gentium-book-basic-${version}";
  major = "1";
  minor = "102";
  version = "${major}.${minor}";

  src = fetchzip {
    name = "${name}.zip";
    url = "http://software.sil.org/downloads/gentium/GentiumBasic_${major}${minor}.zip";
    sha256 = "109yiqwdfb1bn7d6bjp8d50k1h3z3kz86p3faz11f9acvsbsjad0";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v FONTLOG.txt GENTIUM-FAQ.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = "http://software.sil.org/gentium/";
    description = "A high-quality typeface family for Latin, Cyrillic, and Greek";
    maintainers = with maintainers; [ DamienCassou ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
