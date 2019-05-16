{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libburn-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "1gg2kgnqvaa2fwghai62prxz6slpak1f6bvgjh8m4dn16v114asq";
  };

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
