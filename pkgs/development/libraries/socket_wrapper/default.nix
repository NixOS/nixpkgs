{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "socket_wrapper-1.1.3";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "04xfa4yhcaj63ymagmlx77fakrx3wb8ss42m15pmwjaiyi2xndx3";
  };

  buildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "a library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
