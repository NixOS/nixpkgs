{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gfortran,
  blas,
  boost,
  python3,
  ocl-icd,
  opencl-headers,
  Accelerate,
  CoreGraphics,
  CoreVideo,
  OpenCL,
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

  patches = [
    ./platform.patch
    (fetchpatch {
      url = "https://github.com/clMathLibraries/clBLAS/commit/68ce5f0b824d7cf9d71b09bb235cf219defcc7b4.patch";
      hash = "sha256-XoVcHgJ0kTPysZbM83mUX4/lvXVHKbl7s2Q8WWiUnMs=";
    })
  ];

  postPatch = ''
    sed -i -re 's/(set\(\s*Boost_USE_STATIC_LIBS\s+).*/\1OFF\ \)/g' src/CMakeLists.txt
  '';

  preConfigure = ''
    cd src
  '';

  cmakeFlags = [
    "-DBUILD_TEST=OFF"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
    python3
  ];
  buildInputs =
    [
      blas
      boost
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      ocl-icd
      opencl-headers
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Accelerate
      CoreGraphics
      CoreVideo
    ];
  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    OpenCL
  ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/clMathLibraries/clBLAS";
    description = "Software library containing BLAS functions written in OpenCL";
    longDescription = ''
      This package contains a library of BLAS functions on top of OpenCL.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.unix;
  };

}
