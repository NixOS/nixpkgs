{ lib, stdenv, fetchFromGitHub, cmake, python3, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2.0.17";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v2022.05.18"; # XXX: tag uses different name than current release
    hash = "sha256-u4hbcBw3KEPo0+RC7lgPlExS5ZyDubxiLXN9ya0Ork8=";
  };

  nativeBuildInputs = [ cmake python3 ];

  propagatedBuildInputs = [ opencl-headers ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_TESTS=OFF"
  ];

  meta = with lib; {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
