{ stdenv, lib, fetchurl, autoconf, automake, libtool, dos2unix, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libuna";

  src = fetchurl {
    url = "https://github.com/libyal/libuna/archive/20150927.tar.gz";
    sha256 = "0dyvsrbwy6hd6yli57rqpl4q1kfvvs40fvrm4ngna8fnhgvykvlb";
  };

  buildInputs = [ autoconf automake libtool dos2unix ];
  nativeBuildInputs = [ pkgconfig ];

  preConfigure = "dos2unix configure.ac; sh autogen.sh;";

  meta = with lib; {
    description = "Library to support Unicode and ASCII (byte string) conversions";
    homepage = "https://github.com/libyal/libuna";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

