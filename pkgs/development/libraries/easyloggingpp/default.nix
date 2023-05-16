# To use this package with a CMake and pkg-config build:
# pkg_check_modules(EASYLOGGINGPP REQUIRED easyloggingpp)
# add_executable(main src/main.cpp ${EASYLOGGINGPP_PREFIX}/include/easylogging++.cc)
{ lib, stdenv, fetchFromGitHub, cmake, gtest }:
stdenv.mkDerivation rec {
  pname = "easyloggingpp";
<<<<<<< HEAD
  version = "9.97.1";
=======
  version = "9.97.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "amrayn";
    repo = "easyloggingpp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-R4NdwsUywgJoK5E/OdZXFds6iBKOsMa0E+2PDdQbV6E=";
=======
    sha256 = "sha256-sFWmZMnucMuvpwDzuowni21KiD3bx0lH1Ts+yhusOYs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [cmake];
  buildInputs = [gtest];
  cmakeFlags = [ "-Dtest=ON" ];
  env.NIX_CFLAGS_COMPILE = "-std=c++11" +
    lib.optionalString stdenv.isLinux " -pthread";
  postInstall = ''
    mkdir -p $out/include
    cp ../src/easylogging++.cc $out/include
  '';
  meta = {
    description = "C++ logging library";
    homepage = "https://github.com/amrayn/easyloggingpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [acowley];
    platforms = lib.platforms.all;
  };
}
