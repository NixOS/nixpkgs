{ stdenv, fetchFromGitHub, cmake, python, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${version}";
    sha256 = "sha256-7pIItFeFBEFL56gCLDToa9kpfAC279VwpFQXwqfWDBI=";
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
