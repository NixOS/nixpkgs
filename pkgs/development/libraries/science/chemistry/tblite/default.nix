{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, gfortran
, meson
, ninja
, pkg-config
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

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
  ];

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

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Light-weight tight-binding framework";
    mainProgram = "tblite";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    homepage = "https://github.com/tblite/tblite";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
