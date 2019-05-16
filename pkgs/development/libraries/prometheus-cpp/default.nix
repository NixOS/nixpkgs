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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1a0gpfmk0z9wgsbzvx823aqbs7w836l0j0rnsxl9ifwgdxnxbl6m";
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
