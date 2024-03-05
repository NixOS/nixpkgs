{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, gfortran
, blas
, lapack
, mctc-lib
, mstore
, toml-f
, multicharge
, dftd4
, simple-dftd3
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "tblite";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tblite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-R7CAFG/x55k5Ieslxeq+DWq1wPip4cI+Yvn1cBbeVNs=";
  };

  patches = [
    # toml-f 0.4 compatibility
    (fetchpatch {
      url = "https://github.com/tblite/tblite/commit/da759fd02b8fbf470a5c6d3df9657cca6b1d0a9a.diff";
      hash = "sha256-VaeA2VyK+Eas432HMSpJ0lXxHBBNGpfkUO1eHeWpYl0=";
    })
  ];

  # Fix the Pkg-Config files for doubled store paths
  postPatch = ''
    substituteInPlace config/template.pc \
      --replace "\''${prefix}/" ""
  '';

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [
    blas
    lapack
    mctc-lib
    mstore
    toml-f
    multicharge
    dftd4
    simple-dftd3
  ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Light-weight tight-binding framework";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    homepage = "https://github.com/tblite/tblite";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
