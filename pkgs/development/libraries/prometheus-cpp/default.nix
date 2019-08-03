{ stdenv
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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "15bda1q1jbvixbx1qf41ykcdmsywhhwmi4xgsha12r5m9fh8jzxj";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gbenchmark civetweb gtest zlib curl ];

  strictDeps = true;

  cmakeFlags = [
    "-DUSE_THIRDPARTY_LIBRARIES=OFF"
    "-DCIVETWEB_INCLUDE_DIR=${civetweb.dev}/include"
    "-DCIVETWEB_CXX_LIBRARY=${civetweb}/lib/libcivetweb${stdenv.targetPlatform.extensions.sharedLibrary}"
  ];

  NIX_LDFLAGS = [ "-ldl" ];

  meta = {
    description = "Prometheus Client Library for Modern C++";
    homepage = https://github.com/jupp0r/prometheus-cpp;
    license = [ stdenv.lib.licenses.mit ];
  };

}
