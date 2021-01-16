{ stdenv, lib, fetchFromGitHub, pkg-config
, yosys, readline, zlib, bluespec
}:

stdenv.mkDerivation {
  pname = "yosys-bluespec";
  version = "2021.01.14";

  src = fetchFromGitHub {
    owner  = "thoughtpolice";
    repo   = "yosys-bluespec";
    rev    = "7a0c609e9b601560067c34b8ce41e89ea4a397d4";
    sha256 = "0xj9j5dwvq0dwqzfjd4ikmxkd28amj6d9m6ava7pwcrpjhyjnd0c";
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
