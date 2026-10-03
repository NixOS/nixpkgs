{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cmake-modules-webos";
  version = "19";

  src = fetchFromGitHub {
    owner = "openwebos";
    repo = "cmake-modules-webos";
    rev = "submissions/${version}";
    hash = "sha256-t1vnMEV/2/rm7yDIg8f0uMQZQvBaEBNeuhMl9iq7kNA=";
  };

  nativeBuildInputs = [ cmake ];

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace "CMAKE_ROOT}/Modules" "CMAKE_INSTALL_PREFIX}/lib/cmake"
    substituteInPlace webOS/webOS.cmake \
      --replace ' ''${CMAKE_ROOT}/Modules' " $out/lib/cmake" \
      --replace 'INSTALL_ROOT}/usr' 'INSTALL_ROOT}'

    sed -i '/CMAKE_INSTALL_PREFIX/d' webOS/webOS.cmake
  '';

  setupHook = ./cmake-setup-hook.sh;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.7)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace webOS/webOS.cmake \
      --replace-fail "cmake_minimum_required(VERSION 2.8.7)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "CMake modules needed to build Open WebOS components";
    homepage = "https://github.com/openwebos/cmake-modules-webos";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
