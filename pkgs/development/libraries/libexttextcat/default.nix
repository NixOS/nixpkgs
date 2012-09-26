{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libexttextcat-3.3.1";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/libexttextcat/${name}.tar.xz";
    sha256 = "1a7ablpipfbiyhl6wsraj5z8pj3qkqgnrms73wzsqhpbyww334h4";
  };

  patches = [ ./memory-leaks.patch ];

  meta = {
    description = "An N-Gram-Based Text Categorization library primarily intended for language guessing";
    homepage = http://www.freedesktop.org/wiki/Software/libexttextcat;
    platforms = stdenv.lib.platforms.all;
  };
}
