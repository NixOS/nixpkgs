{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libcli";
  version = "1.10.7";

  src = fetchFromGitHub {
    sha256 = "1vqhkz8la6plwz0272m49dzkhv2b4p6gr92355mnmnkir5yrkn92";
    rev = "V${version}";
    repo = "libcli";
    owner = "dparrish";
  };

  enableParallelBuilding = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "AR=${stdenv.cc.targetPrefix}ar" "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = "https://dparrish.com/pages/libcli";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
