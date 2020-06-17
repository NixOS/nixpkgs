{ stdenv, fetchFromGitHub, cmake, python, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${version}";
    sha256 = "0a0n0f1lb86cwfm0ndzykcn965vz1v0n9n3rfmkiwrzkdhc9iy2y";
  };

  nativeBuildInputs = [ cmake python ];

  propagatedBuildInputs = [ opencl-headers ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_TESTS=OFF"
  ];

  meta = with stdenv.lib; {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
