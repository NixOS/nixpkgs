{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "google-gflags-${version}";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "v${version}";
    sha256 = "0qxvr9cyxq3px60jglkm94pq5bil8dkjjdb99l3ypqcds7iypx9w";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=ON"
    "-DBUILD_TESTING=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = false;

  meta = {
    description = "A C++ library that implements commandline flags processing";
    longDescription = ''
      The gflags package contains a C++ library that implements commandline flags processing.
      As such it's a replacement for getopt().
      It was owned by Google. google-gflags project has been renamed to gflags and maintained by new community.
    '';
    homepage = https://code.google.com/p/gflags/;
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.linquize ];
    platforms = stdenv.lib.platforms.all;
  };
}
