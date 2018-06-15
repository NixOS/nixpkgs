{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.12.3";

  src = fetchurl {
    url = "http://download.filezilla-project.org/libfilezilla/${name}.tar.bz2";
    sha256 = "1v606kcz2rdmmlwxrv3xvwh7ia1nh6jfc9bhjw2r4ai3rm16gch5";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
