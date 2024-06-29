{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "socket_wrapper";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://samba/cwrap/socket_wrapper-${version}.tar.gz";
    sha256 = "sha256-CgjsJJ3Z/7s7FtV3s1LVc1YfV77uw1lhgqxuyORrmrY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "Library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
