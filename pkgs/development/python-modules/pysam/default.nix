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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pysam";
  version = "0.23.3";
  pyproject = true;

  # Fetching from GitHub instead of PyPi cause the 0.13 src release on PyPi is
  # missing some files which cause test failures.
  # Tracked at: https://github.com/pysam-developers/pysam/issues/616
  src = fetchFromGitHub {
    owner = "pysam-developers";
    repo = "pysam";
    tag = "v${version}";
    hash = "sha256-yOLnfuGQW+j0nHy4MRlwurZMpeRHTGmQ9eLmihcAGoQ=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    samtools
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
    "pysam.libcsamtools"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python module for reading, manipulating and writing genome data sets";
    downloadPage = "https://github.com/pysam-developers/pysam";
    changelog = "https://github.com/pysam-developers/pysam/releases/tag/${src.tag}";
    homepage = "https://pysam.readthedocs.io";
    maintainers = with lib.maintainers; [ unode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
