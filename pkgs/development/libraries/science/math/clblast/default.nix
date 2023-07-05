{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, opencl-headers
, ocl-icd
}:

stdenv.mkDerivation rec {
  pname = "clblast";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "CNugteren";
    repo = "CLBlast";
    rev = version;
    hash = "sha256-eRwSfP6p0+9yql7TiXZsExRMcnnBLXXW2hh1JliYU2I=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    opencl-headers
    ocl-icd
  ];

  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "The tuned OpenCL BLAS library";
    homepage = "https://github.com/CNugteren/CLBlast";
    license = licenses.asl20;
    maintainers = with maintainers; [ Tungsten842 ];
    platforms = platforms.linux;
  };
}
