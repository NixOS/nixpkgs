{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "socket_wrapper";
  version = "1.3.3";

  src = fetchurl {
    url = "mirror://samba/cwrap/socket_wrapper-${version}.tar.gz";
    sha256 = "sha256-G42i+w7n3JkPvOc039I+frzDnq1GGGyQqUkMFdoebhM=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
