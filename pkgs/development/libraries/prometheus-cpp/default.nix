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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pjz29ywzfg3blhg2v8fn7gjvq46k3bqn7y0xvmn468ixxhv21fi";
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

  meta = {
    description = "Prometheus Client Library for Modern C++";
    homepage = https://github.com/jupp0r/prometheus-cpp;
    license = [ stdenv.lib.licenses.mit ];
  };

}
