{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "source-code-pro-${version}";
  version = "1.017";

  src = fetchurl {
    url="https://github.com/adobe-fonts/source-code-pro/archive/${version}R.tar.gz";
    sha256="03q4a0f142c6zlngv6kjaik52y0yzwq5z5qj3j0fvvcbfy9sanjr";
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
