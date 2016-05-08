{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "5.3";

  src = fetchurl {
    url = "http://archive.rycee.net/pecita/${name}.tar.xz";
    sha256 = "1glr21gi1b9db17ln8qn4zk9gwpxs0frm76i4hp3anlpivbwiis8";
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
