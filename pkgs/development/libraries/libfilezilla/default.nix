{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "http://download.filezilla-project.org/libfilezilla/${name}.tar.bz2";
    sha256 = "10ik96s4r8kbgc5z4z5mqk8w1p3plakqavf6j86a48gl8in1f45x";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
