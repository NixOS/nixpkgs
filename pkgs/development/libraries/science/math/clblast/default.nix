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
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "CNugteren";
    repo = "CLBlast";
    rev = version;
    hash = "sha256-fzenYFCAQ0B2NQgh5OaErv/yNEzjznB6ogRapqfL6P4=";
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
    description = "Tuned OpenCL BLAS library";
    homepage = "https://github.com/CNugteren/CLBlast";
    license = licenses.asl20;
    maintainers = with maintainers; [ Tungsten842 ];
    platforms = platforms.linux;
  };
}
