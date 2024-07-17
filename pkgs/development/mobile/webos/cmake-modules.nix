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
    sha256 = "1l4hpcmgc98kp9g1642sy111ki5qyk3q7j10xzkgmnvz8lqffnxp";
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

  meta = with lib; {
    description = "CMake modules needed to build Open WebOS components";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
