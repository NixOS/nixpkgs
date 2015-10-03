{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "socket_wrapper-1.1.4";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "0ypp7sx5rhn4jpmn5yxgr7mm5kkdcsa76xfnhgsvhagh1naqap2k";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ (stdenv.cc.libc.out or null) ];

  meta = with stdenv.lib; {
    description = "a library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
