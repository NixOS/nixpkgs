{ stdenv, lib, fetchFromGitHub, pkg-config
, yosys, readline, zlib, ghdl
}:

stdenv.mkDerivation {
  pname = "yosys-ghdl";
  version = "2021.01.01";

  src = fetchFromGitHub {
    owner  = "ghdl";
    repo   = "ghdl-yosys-plugin";
    rev    = "8b3e740fef9a653a20a838f1ade475960e1d379b";
    sha256 = "13kpcp37r11xgqd8aksddi40a5vpzqi7p8qgyjbs99lyscyli75x";
  };

  buildInputs = [ yosys readline zlib ghdl ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;
  installPhase = ''
    mkdir -p $out/share/yosys/plugins
    cp ghdl.so $out/share/yosys/plugins/ghdl.so
  '';

  meta = with lib; {
    description = "GHDL plugin for Yosys";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
