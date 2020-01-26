{ lib
, buildPythonPackage
, fetchFromGitHub
, bzip2
, bcftools
, curl
, cython
, htslib
, lzma
, pytest
, samtools
, zlib
}:

buildPythonPackage rec {
  pname   = "pysam";
  version = "0.15.3";

  # Fetching from GitHub instead of PyPi cause the 0.13 src release on PyPi is
  # missing some files which cause test failures.
  # Tracked at: https://github.com/pysam-developers/pysam/issues/616
  src = fetchFromGitHub {
    owner = "pysam-developers";
    repo = "pysam";
    rev = "v${version}";
    sha256 = "0g6md20gsr24pdr9b8nj403w31ixfjv8bjhdvg3x476kjiq1kvyb";
  };

  buildInputs = [ bzip2 curl cython lzma zlib ];

  checkInputs = [ pytest bcftools htslib samtools ];

  checkPhase = "py.test";

  preInstall = ''
    export HOME=$(mktemp -d)
    make -C tests/pysam_data
    make -C tests/cbcf_data
  '';

  meta = {
    homepage = https://pysam.readthedocs.io/;
    description = "A python module for reading, manipulating and writing genome data sets";
    maintainers = with lib.maintainers; [ unode ];
    license = lib.licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
