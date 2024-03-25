{ lib, stdenv, fetchFromGitHub, cmake, python3, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2023.12.14";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${version}";
    sha256 = "sha256-BMpKkS2ISO0F5HNPoVYL38p84VvEAdqqY46bYdiPT0E=";
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
