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
  buildInputs = [ gbenchmark gtest zlib curl ];
  propagatedBuildInputs = [ civetweb ];
  strictDeps = true;

  cmakeFlags = [
    "-DUSE_THIRDPARTY_LIBRARIES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  outputs = [ "out" "dev" ];

  # https://github.com/jupp0r/prometheus-cpp/issues/587
  postPatch = ''
    substituteInPlace cmake/prometheus-cpp-core.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace cmake/prometheus-cpp-pull.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace cmake/prometheus-cpp-push.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    substituteAll ${./prometheus-cpp.pc.in} $dev/lib/pkgconfig/prometheus-cpp.pc
  '';

  meta = {
    description = "Prometheus Client Library for Modern C++";
    homepage = "https://github.com/jupp0r/prometheus-cpp";
    license = [ lib.licenses.mit ];
  };

}
