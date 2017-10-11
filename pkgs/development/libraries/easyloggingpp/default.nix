# To use this package with a CMake and pkg-config build:
# pkg_check_modules(EASYLOGGINGPP REQUIRED easyloggingpp)
# add_executable(main src/main.cpp ${EASYLOGGINGPP_PREFIX}/include/easylogging++.cc)
{ stdenv, fetchFromGitHub, cmake, gtest }:
stdenv.mkDerivation rec {
  name = "easyloggingpp-${version}";
  version = "9.95.0";
  src = fetchFromGitHub {
    owner = "muflihun";
    repo = "easyloggingpp";
    rev = "v${version}";
    sha256 = "0gzmznw6ffag9x55lixxffy6x7mvb7691x0md4q9rbh88zkws7kq";
  };
  nativeBuildInputs = [cmake];
  buildInputs = [gtest];
  cmakeFlags = [ "-Dtest=ON" ];
  NIX_CFLAGS_COMPILE = "-std=c++11" +
    stdenv.lib.optionalString stdenv.isLinux " -pthread";
  postInstall = ''
    mkdir -p $out/include
    cp ../src/easylogging++.cc $out/include
    mkdir -p $out/lib/pkgconfig
    cat << EOF > $out/lib/pkgconfig/easyloggingpp.pc
    Name: easyloggingpp
    Description: A C++ Logging Library
    Version: ${version}
    prefix=$out
    includedir=\''${prefix}/include
    Cflags: -I\''${includedir}
    EOF
  '';
  meta = {
    description = "C++ logging library";
    homepage = https://muflihun.github.io/easyloggingpp/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [acowley];
    platforms = stdenv.lib.platforms.all;
  };
}
