{ fetchurl, stdenv, ghostscript }:

stdenv.mkDerivation rec {
  name = "libspectre-0.2.6";

  src = fetchurl {
    url = "http://libspectre.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1lqdmi7vx497pbigpp77064a4463lmihzh44898l101c69i7qqrg";
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
