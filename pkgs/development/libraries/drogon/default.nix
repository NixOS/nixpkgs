{ stdenv, fetchFromGitHub, cmake, jsoncpp, libuuid, zlib, openssl, lib }:

stdenv.mkDerivation rec {
  pname = "drogon";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "an-tao";
    repo = "drogon";
    rev = "v${version}";
    sha256 = "0ncdlsi3zhmpdwh83d52npb1b2q982y858yl88zl2nfq4zhcm3wa";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # examples are used in the test during installCheckPhase, otherwise they are unnecessary
    "-DBUILD_EXAMPLES=${if doInstallCheck then "ON" else "OFF"}"
  ];

  propagatedBuildInputs = [
    jsoncpp
    libuuid
    zlib
    openssl
  ];

  patches = [
    # this part of the test fails because it attempts to configure a CMake project that uses find_package on itself
    # the rest of the test runs fine because it uses executables that are built in buildPhase when BUILD_EXAMPLES is enabled
    ./no_cmake_test.patch
  ];

  installCheckPhase = ''
    cd ..
    patchShebangs test.sh
    ./test.sh
  '';

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/an-tao/drogon";
    description = "C++14/17 based HTTP web application framework";
    license = licenses.mit;
    maintainers = [ maintainers.urlordjames ];
    platforms = platforms.all;
  };
}
