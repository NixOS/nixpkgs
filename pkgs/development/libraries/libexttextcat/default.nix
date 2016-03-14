{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libexttextcat-3.4.1";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/libexttextcat/${name}.tar.xz";
    sha256 = "0g1spzpsfbv3y8k9m1v53imz18437q93iq101hind7m4x00j6wpl";
  };

  meta = {
    description = "An N-Gram-Based Text Categorization library primarily intended for language guessing";
    homepage = http://www.freedesktop.org/wiki/Software/libexttextcat;
    platforms = stdenv.lib.platforms.all;
  };
}
