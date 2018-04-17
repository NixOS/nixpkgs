# To use this package with a CMake and pkg-config build:
# pkg_check_modules(EASYLOGGINGPP REQUIRED easyloggingpp)
# add_executable(main src/main.cpp ${EASYLOGGINGPP_PREFIX}/include/easylogging++.cc)
{ stdenv, fetchFromGitHub, cmake, gtest }:
stdenv.mkDerivation rec {
  name = "easyloggingpp-${version}";
  version = "9.96.2";
  src = fetchFromGitHub {
    owner = "muflihun";
    repo = "easyloggingpp";
    rev = "v${version}";
    sha256 = "0qhf93i2ks9v6rk6n4v3fn7xrkqdwgs6rm6wd0gx9sm2wlq4ancd";
  };

  nativeBuildInputs = [cmake];
  buildInputs = [gtest];
  cmakeFlags = [ "-Dtest=ON" ];
  NIX_CFLAGS_COMPILE = "-std=c++11" +
    stdenv.lib.optionalString stdenv.isLinux " -pthread";
  postInstall = ''
    mkdir -p $out/include
    cp ../src/easylogging++.cc $out/include
  '';
  meta = {
    description = "C++ logging library";
    homepage = https://muflihun.github.io/easyloggingpp/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [acowley];
    platforms = stdenv.lib.platforms.all;
  };
}
