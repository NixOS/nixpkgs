{ fetchurl, stdenv, ghostscript }:

stdenv.mkDerivation rec {
  name = "libspectre-0.2.0";

  src = fetchurl {
    url = "http://libspectre.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0j75c84gqmfr6hbhiydri4msrxns8293lfxi7hkcnfa15v8qa0i0";
  };

  buildInputs = [
    # Need `libgs.so'.
    ghostscript
  ];

  doCheck = true;

  meta = {
    homepage = http://libspectre.freedesktop.org/;
    description = "libspectre, a PostScript rendering library";

    longDescription = ''
      libspectre is a small library for rendering Postscript
      documents.  It provides a convenient easy to use API for
      handling and rendering Postscript documents.
    '';

    license = "GPLv2+";
  };
}
