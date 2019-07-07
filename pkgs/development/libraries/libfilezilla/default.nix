{ stdenv, fetchurl, pkgconfig, nettle }:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.16.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1fd71vmllzvljff5l5ka5wnzbdsxx4i54dpxpklydmbsqpilnv1v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ nettle ];

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
