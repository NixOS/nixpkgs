{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "source-code-pro-${version}";
  version = "2.010";

  src = fetchFromGitHub {
    owner = "adobe-fonts";
    repo = "source-code-pro";
    rev = "2.010R-ro/1.030R-it";
    name = "2.010R-ro-1.030R-it";
    sha256 = "0f40g23lfcajpd5m9r1z7v8x011dsfs6ba7fihjal6yzaf5hb6mh";
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
