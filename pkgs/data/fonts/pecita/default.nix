{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pecita-${version}";
  version = "5.4";

  src = fetchurl {
    url = "http://archive.rycee.net/pecita/${name}.tar.xz";
    sha256 = "1cqzj558ldzzsbfbvlwp5fjh2gxa03l16dki0n8z5lmrdq8hrkws";
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
