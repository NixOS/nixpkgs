{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "5.2";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    sha256 = "1zawd83jrvzxfj5n5m65ja6rcl0w4bm4179g053b0icm152lgmns";
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
