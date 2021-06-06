{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libexttextcat-3.4.5";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libexttextcat/${name}.tar.xz";
    sha256 = "1j6sjwkyhqvsgyw938bxxfwkzzi1mahk66g5342lv6j89jfvrz8k";
  };

  meta = with lib; {
    description = "An N-Gram-Based Text Categorization library primarily intended for language guessing";
    homepage = "https://wiki.documentfoundation.org/Libexttextcat";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
