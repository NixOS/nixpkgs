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
    sha256 = "12s6g7l20kakyjlhqpli496miv2kfsdp17lcwhdrzdxvxl6hnf4n";
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

  meta = with lib; {
    description = "Utility for communicating with WebOS devices";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
