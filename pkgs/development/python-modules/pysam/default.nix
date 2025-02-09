{ lib
, buildPythonPackage
, fetchFromGitHub
, bzip2
, bcftools
, curl
, cython
, htslib
, libdeflate
, xz
, pytestCheckHook
, samtools
, zlib
}:

buildPythonPackage rec {
  pname   = "pysam";
  version = "0.21.0";
  format = "setuptools";

  # Fetching from GitHub instead of PyPi cause the 0.13 src release on PyPi is
  # missing some files which cause test failures.
  # Tracked at: https://github.com/pysam-developers/pysam/issues/616
  src = fetchFromGitHub {
    owner = "pysam-developers";
    repo = "pysam";
    rev = "refs/tags/v${version}";
    hash = "sha256-C4/AJwcUyLoUEUEnsATLHJb5F8mltP8X2XfktYu0OTo=";
  };

  nativeBuildInputs = [ samtools ];

  buildInputs = [
    bzip2
    curl
    libdeflate
    xz
    zlib
  ];

  propagatedBuildInputs = [ cython ];

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

  meta = with lib; {
    description = "A python module for reading, manipulating and writing genome data sets";
    homepage = "https://pysam.readthedocs.io/";
    maintainers = with maintainers; [ unode ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
