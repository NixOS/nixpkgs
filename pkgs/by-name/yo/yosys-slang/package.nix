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
    rev = "23e0653c85f6ed4127e665a2529b069ce550e967";
    hash = "sha256-7axr4JyxTtnCbI6l23A9LoBco3b3bqEMKoTEc1KNOQI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    yosys
    readline
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
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
    maintainers = [ ];
  };
}
