{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "crimson-${version}";
  version = "2014.10";

  src = fetchurl {
    url = "https://github.com/skosch/Crimson/archive/fonts-october2014.tar.gz";
    sha256 = "0qyihrhqb89vwg9cfpaf5xqmcjvs4r4614bxy634vmqv9v1bzn5b";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "Desktop Fonts/OTF/"*.otf $out/share/fonts/opentype
    cp -v README.md $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = https://aldusleaf.org/crimson.html;
    description = "A font family inspired by beautiful oldstyle typefaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
