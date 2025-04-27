{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bzip2,
  bcftools,
  curl,
  cython,
  htslib,
  libdeflate,
  xz,
  pytestCheckHook,
  setuptools,
  samtools,
  zlib,
}:

buildPythonPackage {
  pname = "pysam";
  version = "0.22.1-unstable-2024-10-30";
  pyproject = true;

  # Fetching from GitHub instead of PyPi cause the 0.13 src release on PyPi is
  # missing some files which cause test failures.
  # Tracked at: https://github.com/pysam-developers/pysam/issues/616
  src = fetchFromGitHub {
    owner = "pysam-developers";
    repo = "pysam";
    rev = "0eae5be21ac3ab3ac7aa770a3931e2977e37b909";
    hash = "sha256-i8glYSpuCRNhNtK4i6eUrerz8daiMfY/YgDwgSuELbc=";
  };

  nativeBuildInputs = [
    cython
    samtools
    setuptools
  ];

  buildInputs = [
    bzip2
    curl
    libdeflate
    xz
    zlib
  ];

  # Use nixpkgs' htslib instead of the bundled one
  # See https://pysam.readthedocs.io/en/latest/installation.html#external
  # NOTE that htslib should be version compatible with pysam
  preBuild = ''
    export HTSLIB_MODE=shared
    export HTSLIB_LIBRARY_DIR=${htslib}/lib
    export HTSLIB_INCLUDE_DIR=${htslib}/include
  '';

  nativeCheckInputs = [
    pytestCheckHook
    bcftools
    htslib
  ];

  preCheck = ''
    export HOME=$TMPDIR
    make -C tests/pysam_data
    make -C tests/cbcf_data
    make -C tests/tabix_data
    rm -rf pysam
  '';

  pythonImportsCheck = [
    "pysam"
    "pysam.bcftools"
    "pysam.libchtslib"
    "pysam.libcutils"
    "pysam.libcvcf"
  ];

  meta = {
    description = "Python module for reading, manipulating and writing genome data sets";
    downloadPage = "https://github.com/pysam-developers/pysam";
    homepage = "https://pysam.readthedocs.io";
    maintainers = with lib.maintainers; [ unode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
