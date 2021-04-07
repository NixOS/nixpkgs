{ fetchurl, lib, stdenv, pkg-config, ghostscript, cairo }:

stdenv.mkDerivation rec {
  name = "libspectre-0.2.7";

  src = fetchurl {
    url = "https://libspectre.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1v63lqc6bhhxwkpa43qmz8phqs8ci4dhzizyy16d3vkb20m846z8";
  };

  patches = [ ./libspectre-0.2.7-gs918.patch ];

  buildInputs = [
    # Need `libgs.so'.
    pkg-config ghostscript cairo /*for tests*/
  ];

  doCheck = true;

  meta = {
    homepage = "http://libspectre.freedesktop.org/";
    description = "PostScript rendering library";

    longDescription = ''
      libspectre is a small library for rendering Postscript
      documents.  It provides a convenient easy to use API for
      handling and rendering Postscript documents.
    '';

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
