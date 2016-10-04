{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "socket_wrapper-1.1.5";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "01gn21kbicwfn3vlnnir8c11z2g54b532bj3qrpdrhgrcm3ifi45";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "A library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
