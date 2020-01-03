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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j12ir8skw3y2q8n743zql4ddp7v1j4h030pjcsqn0xqrqw7m5hg";
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
