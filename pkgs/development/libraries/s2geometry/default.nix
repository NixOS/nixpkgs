{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, openssl, gtest, abseil-cpp }:

stdenv.mkDerivation rec {
  pname = "s2geometry";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "s2geometry";
    rev = "v${version}";
    hash = "sha256-FV3F4mkgl5O8dPUFzsYzaSksp412W5TREmNasPHQ2fg=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl gtest abseil-cpp ];

  # Default of C++11 is too low for gtest.
  # In newer versions of s2geometry this can be done with cmakeFlags.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "CMAKE_CXX_STANDARD 11" "CMAKE_CXX_STANDARD 14"
  '';

  meta = with lib; {
    description = "Computational geometry and spatial indexing on the sphere";
    homepage = "http://s2geometry.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.unix;
  };
}
