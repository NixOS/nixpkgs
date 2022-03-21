{ lib
, stdenv
, fetchFromGitHub
, cmake
, gbenchmark
, gtest
, civetweb
, zlib
, curl
}:

stdenv.mkDerivation rec {
  pname = "prometheus-cpp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "L6CXRup3kU1lY5UnwPbaOwEtCeAySNmFCPmHwsk6cRE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gbenchmark civetweb gtest zlib curl ];

  strictDeps = true;

  cmakeFlags = [
    "-DUSE_THIRDPARTY_LIBRARIES=OFF"
    "-DCIVETWEB_INCLUDE_DIR=${civetweb.dev}/include"
    "-DCIVETWEB_CXX_LIBRARY=${civetweb}/lib/libcivetweb${stdenv.targetPlatform.extensions.sharedLibrary}"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  NIX_LDFLAGS = "-ldl";

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./prometheus-cpp.pc.in} $out/lib/pkgconfig/prometheus-cpp.pc
  '';

  meta = {
    description = "Prometheus Client Library for Modern C++";
    homepage = "https://github.com/jupp0r/prometheus-cpp";
    license = [ lib.licenses.mit ];
  };

}
