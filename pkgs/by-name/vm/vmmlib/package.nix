{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  lapack,
}:

stdenv.mkDerivation rec {
  version = "1.14.0";
  pname = "vmmlib";

  src = fetchFromGitHub {
    owner = "Eyescale";
    repo = "vmmlib";
    tag = "${version}";
    hash = "sha256-QEfeQcE66XbsFTN/Fojgldem5C+RhbOBmRyBX3sfUrg=";

    fetchSubmodules = true;
  };

  cmakeFlags = [
    # Prevent -Werror=deprecated-copy from failing the build
    "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-copy"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    boost
    lapack
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "include(CPackConfig)" ""
    substituteInPlace CMake/common/Common.cmake \
      --replace-fail "cmake_minimum_required(VERSION 3.1 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkTarget = "test";

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Vector and matrix math library implemented using C++ templates";

    longDescription = ''
      vmmlib is a vector and matrix math library implemented
      using C++ templates. Its basic functionality includes a vector
      and a matrix class, with additional functionality for the
      often-used 3d and 4d vectors and 3x3 and 4x4 matrices.
      More advanced functionality include solvers, frustum
      computations and frustum culling classes, and spatial data structures
    '';

    license = licenses.bsd2;
    homepage = "https://github.com/VMML/vmmlib/";
    maintainers = [ maintainers.adev ];
    platforms = platforms.all;
  };
}
