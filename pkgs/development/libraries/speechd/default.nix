{ fetchurl, stdenv, dotconf, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "speech-dispatcher-" + version;
  version = "0.7.1";

  src = fetchurl {
    url = "http://www.freebsoft.org/pub/projects/speechd/${name}.tar.gz";
    sha256 = "0laag72iw03545zggdzcr860b8q7w1vrjr3csd2ldps7jhlwzad8";
  };

  buildInputs = [ dotconf glib pkgconfig ];

  meta = {
    description = "Common interface to speech synthesis";

    homepage = http://www.freebsoft.org/speechd;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
