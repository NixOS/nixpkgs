{ stdenv, lib, fetchFromGitHub, pkg-config
, yosys, readline, zlib, bluespec
}:

stdenv.mkDerivation {
  pname = "yosys-bluespec";
  version = "2021.09.08";
  plugin = "bluespec";

  src = fetchFromGitHub {
    owner  = "thoughtpolice";
    repo   = "yosys-bluespec";
    rev    = "f6f4127a4e96e18080fd5362b6769fa3e24c76b1";
    sha256 = "sha256-3cNFP/k4JsgLyUQHWU10Htl2Rh0staAcA3R4piD6hDE=";
  };

  buildInputs = [ yosys readline zlib bluespec ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;
  makeFlags = [
    "PREFIX=$(out)/share/yosys/plugins"
    "STATIC_BSC_PATH=${bluespec}/bin/bsc"
    "STATIC_BSC_LIBDIR=${bluespec}/lib"
  ];

  meta = with lib; {
    description = "Bluespec plugin for Yosys";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
