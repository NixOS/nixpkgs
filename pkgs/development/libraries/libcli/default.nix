{ lib, stdenv, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libcli";
  version = "1.9.7";

  src = fetchFromGitHub {
    sha256 = "08pmjhqkwldhmcwjhi2l27slf1fk6nxxfaihnk2637pqkycy8z0c";
    rev = "v${version}";
    repo = "libcli";
    owner = "dparrish";
  };

  patches =
    [ (fetchurl {
        url = "https://github.com/dparrish/libcli/commit/ebc5a09db457ee1be9996711463cbbafe5ea72d5.patch";
        sha256 = "0szjiw3gd7by1sv924shnngfxvc98xvaqvx228b575xq93xxjcwl";
      })
    ];

  enableParallelBuilding = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "AR=${stdenv.cc.targetPrefix}ar" "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = "http://sites.dparrish.com/libcli";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
