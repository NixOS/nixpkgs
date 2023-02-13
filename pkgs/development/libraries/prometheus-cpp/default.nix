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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F8paJhptEcOMtP0FCJ3ragC4kv7XSVPiZheM5UZChno=";
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
