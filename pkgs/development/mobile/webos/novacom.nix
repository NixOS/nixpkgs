{
  lib,
  stdenv,
  fetchFromGitHub,
  webos,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "novacom";
  version = "18";

  src = fetchFromGitHub {
    owner = "openwebos";
    repo = "novacom";
    rev = "submissions/${version}";
    hash = "sha256-ljgLDe27t58b5IyecJt2U+xYTSKRXgyp9FNNIOh5Ros=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    webos.cmake-modules
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.7)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    install -Dm755 -t $out/bin ../scripts/novaterm
    substituteInPlace $out/bin/novaterm --replace "exec novacom" "exec $out/bin/novacom"
  '';

  meta = {
    description = "Utility for communicating with WebOS devices";
    homepage = "https://github.com/openwebos/novacom";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
