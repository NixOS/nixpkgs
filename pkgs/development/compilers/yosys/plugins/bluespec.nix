{ stdenv, lib, fetchFromGitHub, pkg-config
, yosys, readline, zlib, bluespec
}:

stdenv.mkDerivation {
  pname = "yosys-bluespec";
  version = "2021.01.17";

  src = fetchFromGitHub {
    owner  = "thoughtpolice";
    repo   = "yosys-bluespec";
    rev    = "3cfa22c2810b840f406610efe3d7657477c1b0ed";
    sha256 = "1r48128yisw5lpziaj3hq88acghwi94pvm4735xajx8dl79jkcng";
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
