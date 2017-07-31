{ stdenv, fetchurl, cmake, qt4, perl, bzip2, libxml2, exiv2
, clucene_core, fam, zlib, dbus_tools, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "strigi-${version}";
  version = "0.7.8";

  src = fetchurl {
    url = "http://www.vandenoever.info/software/strigi/${name}.tar.bz2";
    sha256 = "12grxzqwnvbyqw7q1gnz42lypadxmq89vk2qpxczmpmc4nk63r23";
  };

  includeAllQtDirs = true;

  CLUCENE_HOME = clucene_core;

  buildInputs =
    [ zlib bzip2 libxml2 qt4 exiv2 clucene_core fam dbus_tools ];

  nativeBuildInputs = [ cmake pkgconfig perl ];

  patches = [ ./export_bufferedstream.patch ./gcc6.patch ];

  enableParallelBuilding = true;

  # Strigi installs some libraries in an incorrect place
  # ($out/$out/lib instead of $out/lib), so move them to the right
  # place.
  postInstall =
    ''
      mv $out/$out/lib/* $out/lib
      rm -rf $out/nix
    '';

  meta = {
    homepage = http://strigi.sourceforge.net;
    description = "A very fast and efficient crawler to index data on your harddrive";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander ];
    inherit (qt4.meta) platforms;
  };
}
