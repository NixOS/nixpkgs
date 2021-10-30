{ stdenv, lib, fetchFromGitHub, pkg-config
, yosys, readline, zlib, bluespec
}:

stdenv.mkDerivation {
  pname = "yosys-bluespec";
  version = "2021.08.19";

  src = fetchFromGitHub {
    owner  = "thoughtpolice";
    repo   = "yosys-bluespec";
    rev    = "bcea1635c97747acd3bcb5b8f1968b3f57ae62bc";
    sha256 = "0ipx9yjngs3haksdb440wlydviszwqnxgzynpp7yic2x3ai7i8m1";
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
