{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  yosys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yosys-slang";
  version = "0-unstable-2026-01-31";
  plugin = "slang";

  src = fetchFromGitHub {
    owner = "povik";
    repo = "yosys-slang";
    rev = "4e1ad7c11e23cffe131aa5c478083f1d99f0c0be";
    hash = "sha256-4uKvtBUdDYm7ZERLcjWObvkbIARANUWiz4HmZsN2AA4=";
    fetchSubmodules = true;
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
    "-DYOSYS_SLANG_REVISION=${finalAttrs.src.rev}"
    "-DSLANG_REVISION=UNKNOWN"
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
})
