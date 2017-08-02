{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "source-code-pro-${version}";
  version = "2.030";

  src = fetchFromGitHub {
    owner = "adobe-fonts";
    repo = "source-code-pro";
    rev = "2.030R-ro/1.050R-it";
    name = "2.030R-ro-1.050R-it";
    sha256 = "0hc5kflr8xzqgdm0c3gbgb1paygznxmnivkylid69ipc7wnicx1n";
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
    homepage = https://blog.typekit.com/2012/09/24/source-code-pro/;
    license = stdenv.lib.licenses.ofl;
  };
}
