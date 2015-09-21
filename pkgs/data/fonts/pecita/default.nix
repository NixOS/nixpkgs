{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "5.2";

  src = fetchurl {
    url = "http://archive.rycee.net/pecita/${name}.tar.xz";
    sha256 = "0ryfvxdla5iinwwin4dc1k89hk1bjq2mfdrrv67q6fdgz41l0qf0";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v Pecita.otf $out/share/fonts/opentype/Pecita.otf
  '';

  meta = with stdenv.lib; {
    homepage = http://pecita.eu/police-en.php;
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
