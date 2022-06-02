{ lib, stdenv
, fetchFromGitHub
, cmake
, gfortran
, blas
, boost
, python3
, ocl-icd
, opencl-headers
, Accelerate, CoreGraphics, CoreVideo, OpenCL
}:

stdenv.mkDerivation rec {
  pname = "clblas";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "clMathLibraries";
    repo = "clBLAS";
    rev = "v${version}";
    sha256 = "154mz52r5hm0jrp5fqrirzzbki14c1jkacj75flplnykbl36ibjs";
  };

  patches = [ ./platform.patch ];

  postPatch = ''
    sed -i -re 's/(set\(\s*Boost_USE_STATIC_LIBS\s+).*/\1OFF\ \)/g' src/CMakeLists.txt
  '';

  preConfigure = ''
    cd src
  '';

  cmakeFlags = [
     "-DBUILD_TEST=OFF"
  ];

  nativeBuildInputs = [ cmake gfortran ];
  buildInputs = [
    blas
    python3
    boost
  ] ++ lib.optionals (!stdenv.isDarwin) [
    ocl-icd
    opencl-headers
  ] ++ lib.optionals stdenv.isDarwin [
    Accelerate
    CoreGraphics
    CoreVideo
  ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [
    OpenCL
  ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/clMathLibraries/clBLAS";
    description = "A software library containing BLAS functions written in OpenCL";
    longDescription = ''
      This package contains a library of BLAS functions on top of OpenCL.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.unix;
  };

}
