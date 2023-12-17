{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "opencl-headers";
  version = "2023.12.14";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${version}";
    sha256 = "sha256-wF9KQjzYKJf6ulXRy80o53bp6lTtm8q1NubKbcH+RY0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Khronos OpenCL headers version ${version}";
    homepage = "https://www.khronos.org/registry/cl/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
