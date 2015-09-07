{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "source-code-pro-${version}";
  version = "2.010";
  version_italic = "1.030";

  src = fetchurl {
    url="https://github.com/adobe-fonts/source-code-pro/archive/${version}R-ro/${version_italic}R-it.tar.gz";
    sha256="12wijgxrdzqxpw2q420nsq9aj454vhg3rq6n81jbqvgzxhxjpf7w";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp {} $out/share/fonts/opentype \;
  '';

  meta = {
    description = "A set of monospaced OpenType fonts designed for coding environments";
    maintainers = with stdenv.lib.maintainers; [ relrod ];
    platforms = with stdenv.lib.platforms; all;
    homepage = "http://blog.typekit.com/2012/09/24/source-code-pro/";
    license = stdenv.lib.licenses.ofl;
  };
}
