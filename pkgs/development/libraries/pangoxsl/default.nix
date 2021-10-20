{lib, stdenv, fetchurl, pkg-config, glib, pango}:

stdenv.mkDerivation {
  name = "pangoxsl-1.6.0.3";
  src = fetchurl {
    url = "mirror://sourceforge/pangopdf/pangoxsl-1.6.0.3.tar.gz";
    sha256 = "1wcd553nf4nwkrfrh765cyzwj9bsg7zpkndg2hjs8mhwgx04lm8n";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    pango
  ];

  meta = with lib; {
    description = "Implements several of the inline properties defined by XSL that are not currently implemented by Pango";
    homepage = "https://sourceforge.net/projects/pangopdf";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
