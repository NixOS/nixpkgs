{ lib
, stdenv
, fetchFromGitHub
, cmake
, opencl-headers
, ocl-icd
, OpenCL
}:

stdenv.mkDerivation rec {
  pname = "clblast";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "CNugteren";
    repo = "CLBlast";
    rev = version;
    hash = "sha256-1FNt+lVt8AMkkEtkP61ND2ZmsMJ3ZuU2m2yIUt51mSg=";
  };

  patches = [ ./0001-fix-pkg-config-paths.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isLinux [
    opencl-headers
    ocl-icd
  ] ++ lib.optionals stdenv.isDarwin [
    OpenCL
  ];

  meta = with lib; {
    homepage = "https://cnugteren.github.io/clblast";
    changelog = "https://github.com/CNugteren/CLBlast/blob/${version}/CHANGELOG";
    description = "The tuned OpenCL BLAS library";
    license = licenses.asl20;
    maintainers = with maintainers; [ joachimschmidt557 ];
    platforms = platforms.unix;
  };
}
