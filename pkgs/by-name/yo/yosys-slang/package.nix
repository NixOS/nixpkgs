{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  yosys,
  readline,
  zlib,
}:

stdenv.mkDerivation {
  pname = "yosys-slang";
  version = "0-unstable-2025-12-15";
  plugin = "slang";

  src = fetchFromGitHub {
    owner = "povik";
    repo = "yosys-slang";
    rev = "64b44616a3798f07453b14ea03e4ac8a16b77313";
    hash = "sha256-kfu59/M3+IM+5ZMd+Oy4IZf4JWuVtPDlkHprk0FB8t4=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    yosys
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DYOSYS_CONFIG=${yosys}/bin/yosys-config"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/yosys/plugins
    cp slang.so $out/share/yosys/plugins/slang.so
    runHook postInstall
  '';

  doCheck = false; # No tests defined in the plugin itself

  meta = with lib; {
    description = "SystemVerilog frontend plugin for Yosys using the slang library";
    homepage = "https://github.com/povik/yosys-slang";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ lucgaitskell ];
  };
}
