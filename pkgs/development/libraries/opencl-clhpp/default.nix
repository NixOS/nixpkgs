{ stdenv, fetchFromGitHub, cmake, python, opencl-headers }:

stdenv.mkDerivation rec {
  name = "opencl-clhpp-${version}";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${version}";
    sha256 = "0h5kpg5cl8wzfnqmv6i26aig2apv06ffm9p3rh35938n9r8rladm";
  };

  nativeBuildInputs = [ cmake python ];

  propagatedBuildInputs = [ opencl-headers ];

  preConfigure = ''
    cmakeFlags="-DCMAKE_INSTALL_PREFIX=$out/include -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF"
  '';

  meta = with stdenv.lib; {
    description = "OpenCL Host API C++ bindings";
    homepage = http://github.khronos.org/OpenCL-CLHPP/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
