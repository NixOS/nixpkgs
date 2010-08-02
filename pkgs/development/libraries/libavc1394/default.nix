{ stdenv, fetchurl, pkgconfig, libraw1394 }:

stdenv.mkDerivation {
  name = "libavc1394-0.5.3";

  src = fetchurl {
    url = mirror://sourceforge/libavc1394/libavc1394-0.5.3.tar.gz;
    sha256 = "19i40i3722ilhziknfds3a6w5xzv66fvc68gvbir1p2fvwi6ij93";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libraw1394 ];

  meta = { 
    description = "Programming interface for the 1394 Trade Association AV/C (Audio/Video Control) Digital Interface Command Set";
    homepage = http://sourceforge.net/projects/libavc1394/;
    license = [ "GPL" "LGPL" ];
  };
}
