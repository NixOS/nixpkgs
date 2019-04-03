{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "socket_wrapper-1.2.3";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "1jprm8f7xb91b3yrapdbf51l36j6g038n379akz7ds0dicjh0fh7";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "A library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
