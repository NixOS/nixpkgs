{ stdenv, fetchurl, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libmms-0.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/libmms/${name}.tar.gz";
    sha256 = "0kvhxr5hkabj9v7ah2rzkbirndfqdijd9hp8v52c1z6bxddf019w";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Library for downloading (streaming) media files using the mmst and mmsh protocols";
    homepage = "http://libmms.sourceforge.net";
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
