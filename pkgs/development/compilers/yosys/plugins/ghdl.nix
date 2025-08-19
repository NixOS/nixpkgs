{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  yosys,
  readline,
  zlib,
  ghdl,
}:

stdenv.mkDerivation {
  pname = "yosys-ghdl";
  version = "0-unstable-2025-05-23";
  plugin = "ghdl";

  src = fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl-yosys-plugin";
    rev = "1b97dc71377cea7e861be6625be4353c377a5fb5";
    hash = "sha256-TFMUqIXJzgpnZ8cDlVb47btPqsCNJil0MN4Tdt83140=";
  };

  buildInputs = [
    yosys
    readline
    zlib
    ghdl
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  doCheck = true;
  installPhase = ''
    mkdir -p $out/share/yosys/plugins
    cp ghdl.so $out/share/yosys/plugins/ghdl.so
  '';

  meta = with lib; {
    description = "GHDL plugin for Yosys";
    homepage = "https://github.com/ghdl/ghdl-yosys-plugin";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
