{ stdenv, fetchurl, pkgconfig, libraw1394 }:

stdenv.mkDerivation rec {
  name = "libavc1394-0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/libavc1394/${name}.tar.gz";
    sha256 = "0lsv46jdqvdx5hx92v0z2cz3yh6212pz9gk0k3513sbaa04zzcbw";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libraw1394 ];

  meta = { 
    description = "Programming interface for the 1394 Trade Association AV/C (Audio/Video Control) Digital Interface Command Set";
    homepage = https://sourceforge.net/projects/libavc1394/;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
