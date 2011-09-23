{ stdenv, fetchurl, glib, qt4, pkgconfig, libnl, pygobject, python, automake
, autoconf }:

let
  version = "014";
in

stdenv.mkDerivation rec {
  name = "ntrack-${version}";

  src = fetchurl {
    url = "http://launchpad.net/ntrack/main/${version}/+download/${name}.tar.gz";
    sha256 = "1aqn3q0dj2kk0j9rf02qgbfghlykaas7q0g8wxyz7nd6zg4qhyj2";
  };

  buildInputs = [ libnl qt4 ];

  buildNativeInputs = [ pkgconfig python automake autoconf ];

  configureFlags = "--without-gobject CFLAGS=--std=gnu99";

  patchP0 = fetchurl {
    url = http://bazaar.launchpad.net/~asac/ntrack/main/diff/312/309;
    name = "ntrack-bzr-309-to-312.patch";
    sha256 = "1bpjpikln2i7nsmd2gl82g08yzaqac311sgsva7z7pqccxz0vsj5";
  };

  patchP1 = fetchurl {
    url = "https://bugs.launchpad.net/ntrack/+bug/750554/+attachment/2291609/+files/ntrack_libnl_link.diff";
    sha256 = "1al6wfjph7nmck1q2q2z98cnzcrwpln2wwh45xynsxr6wgczwck6";
  };

  patchPhase =
    ''
      patch -p0 < ${patchP0}
      patch -p1 < ${patchP1}
      sed -e "s@/usr\(/lib/ntrack/modules/\)@$out&@" -i common/ntrack.c
    '';

  preConfigure = "automake"; # The second patch changes Makefile.am files
}
