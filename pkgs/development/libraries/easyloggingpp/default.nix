# To use this package with a CMake and pkg-config build:
# pkg_check_modules(EASYLOGGINGPP REQUIRED easyloggingpp)
# add_executable(main src/main.cpp ${EASYLOGGINGPP_PREFIX}/include/easylogging++.cc)
{ lib, stdenv, fetchFromGitHub, cmake, gtest }:
stdenv.mkDerivation rec {
  pname = "easyloggingpp";
  version = "9.97.0";
  src = fetchFromGitHub {
    owner = "amrayn";
    repo = "easyloggingpp";
    rev = "v${version}";
    sha256 = "sha256-sFWmZMnucMuvpwDzuowni21KiD3bx0lH1Ts+yhusOYs=";
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
