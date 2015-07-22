{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "1.1";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    sha256 = "07krzpbmc5yhfbf3aklv1f150i2g1spaan9girmg3189jsn6qw6p";
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
