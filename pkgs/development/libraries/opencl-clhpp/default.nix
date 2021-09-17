{ lib, stdenv, fetchFromGitHub, cmake, python3, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${version}";
    sha256 = "04g3mg2cpbi048fxxkghra81bpxzqr4r3gspx5mvqipx1lzypsci";
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
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
