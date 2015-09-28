{ stdenv, fetchurl, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  name = "libusbmuxd-1.0.10";
  src = fetchurl {
    url = "http://www.libimobiledevice.org/downloads/${name}.tar.bz2";
    sha256 = "1wn9zq2224786mdr12c5hxad643d29wg4z6b7jn888jx4s8i78hs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libplist ];

  meta = {
    homepage = "http://www.libimobiledevice.org";
  };
}
