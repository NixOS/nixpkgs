{ stdenv, fetchFromGitHub, fetchpatch, cmake, enableShared ? true }:

stdenv.mkDerivation rec {
  pname = "fmt";
  version = "7.0.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = version;
    sha256 = "17q2fdzakk5p0s3fx3724gs5k2b5ylp8f1d6j2m3wgvlfldx9k9a";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if enableShared then "ON" else "OFF"}"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    homepage = "http://fmtlib.net/";
    downloadPage = "https://github.com/fmtlib/fmt/";
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
