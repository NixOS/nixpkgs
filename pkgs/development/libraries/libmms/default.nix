{ lib, stdenv, fetchurl, glib, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libmms";
  version = "0.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/libmms/libmms-${version}.tar.gz";
    sha256 = "0kvhxr5hkabj9v7ah2rzkbirndfqdijd9hp8v52c1z6bxddf019w";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Library for downloading (streaming) media files using the mmst and mmsh protocols";
    homepage = "http://libmms.sourceforge.net";
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
