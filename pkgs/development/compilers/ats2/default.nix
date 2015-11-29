{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "0dx3r2vxmarj3aqm0xlcmls1h08pll9y9k4820df41awyrwmfvcy";
  };

  buildInputs = [ gmp ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = stdenv.lib.licenses.gpl3Plus;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
