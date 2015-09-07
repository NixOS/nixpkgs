{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "5.1";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    sha256 = "0v2k6vvzl1f809h3lfld6zy5m56w1dn27xmdy3hjniv6j9xbhbs4";
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v ${src} $out/share/fonts/opentype/Pecita.otf
  '';

  meta = with stdenv.lib; {
    homepage = http://pecita.eu/police-en.php;
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
