{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "socket_wrapper";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://samba/cwrap/socket_wrapper-${version}.tar.gz";
    sha256 = "sha256-IGQQBSyh8hjZuymmRtU4FI2n7FyYmP28Nun9eorvAHY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
