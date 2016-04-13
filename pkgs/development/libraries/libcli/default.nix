{ stdenv, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  name = "libcli-${version}";
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

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Emulate a Cisco-style telnet command-line interface";
    homepage = http://sites.dparrish.com/libcli;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
