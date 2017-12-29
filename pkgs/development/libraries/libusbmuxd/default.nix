{ stdenv, fetchurl, fetchpatch, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  name = "libusbmuxd-1.0.10";
  src = fetchurl {
    url = "http://www.libimobiledevice.org/downloads/${name}.tar.bz2";
    sha256 = "1wn9zq2224786mdr12c5hxad643d29wg4z6b7jn888jx4s8i78hs";
  };

  patches = [
    (fetchpatch { # CVE-2016-5104
      url = "https://github.com/libimobiledevice/libusbmuxd/commit/4397b3376dc4e4cb1c991d0aed61ce6482614196.patch";
      sha256 = "0cl3vys7bkwbdzf64d0rz3zlqpfc30w4l7j49ljv01agh42ywhgk";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libplist ];

  meta = {
    homepage = http://www.libimobiledevice.org;
    platforms = stdenv.lib.platforms.unix;
  };
}
