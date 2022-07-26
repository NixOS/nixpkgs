{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
}:

stdenv.mkDerivation rec {
  pname = "opencl-headers";
  version = "2022.05.18";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${version}";
    hash = "sha256-A2MKU1ppfCKroN4qKGKN9XJvkcGZJy+Kn8FvxceQv7o=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    # Fix CMake-based install on Darwin
    # https://github.com/KhronosGroup/OpenCL-Headers/pull/203
    (fetchpatch {
      url = "https://github.com/KhronosGroup/OpenCL-Headers/commit/7bdd9509899ef9558a71a795b5daa6f6811a165d.patch";
      hash = "sha256-NshYHAJlPWLWnfilgb6KNDerHO3bEiIajTSLkw6Ipl8=";
    })
    (fetchpatch {
      url = "https://github.com/KhronosGroup/OpenCL-Headers/commit/0fbd141e2c18595d5a57590565354c795b9eb8c2.patch";
      hash = "sha256-dPdnTwC0qvsiuHlZSgqb/oyPd1HvvSi5iRRQ/eETV4I=";
    })
  ];

  cmakeFlags = [
    "-DOPENCL_HEADERS_BUILD_TESTING=OFF"
    "-DOPENCL_HEADERS_BUILD_CXX_TESTS=OFF"
  ];

  meta = with lib; {
    description = "Khronos OpenCL headers version ${version}";
    homepage = "https://www.khronos.org/registry/cl/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
