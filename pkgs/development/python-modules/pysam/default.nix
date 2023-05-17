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
, pytest
, samtools
, zlib
}:

buildPythonPackage rec {
  pname   = "pysam";
  version = "0.20.0";

  # Fetching from GitHub instead of PyPi cause the 0.13 src release on PyPi is
  # missing some files which cause test failures.
  # Tracked at: https://github.com/pysam-developers/pysam/issues/616
  src = fetchFromGitHub {
    owner = "pysam-developers";
    repo = "pysam";
    rev = "refs/tags/v${version}";
    hash = "sha256-7yEZJ+iIw4qOxsanlKQlqt1bfi8MvyYjGJWiVDmXBrc=";
  };

  nativeBuildInputs = [ samtools ];
  buildInputs = [
    bzip2
    curl
    cython
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
    pytest
    bcftools
    htslib
  ];

  # See https://github.com/NixOS/nixpkgs/pull/100823 for why we aren't using
  # disabledTests and pytestFlagsArray through pytestCheckHook
  checkPhase = ''
    # Needed to avoid /homeless-shelter error
    export HOME=$(mktemp -d)

    # To avoid API incompatibilities, these should ideally show the same version
    echo "> samtools --version"
    samtools --version
    echo "> htsfile --version"
    htsfile --version
    echo "> bcftools --version"
    bcftools --version

    # Create auxiliary test data
    make -C tests/pysam_data
    make -C tests/cbcf_data

    # Delete pysam folder in current directory to avoid importing it during testing
    rm -rf pysam

    # Deselect tests that are known to fail due to upstream issues
    # See https://github.com/pysam-developers/pysam/issues/961
    py.test \
      --deselect tests/AlignmentFileHeader_test.py::TestHeaderBAM::test_dictionary_access_works \
      --deselect tests/AlignmentFileHeader_test.py::TestHeaderBAM::test_header_content_is_as_expected \
      --deselect tests/AlignmentFileHeader_test.py::TestHeaderCRAM::test_dictionary_access_works \
      --deselect tests/AlignmentFileHeader_test.py::TestHeaderCRAM::test_header_content_is_as_expected \
      --deselect tests/AlignmentFile_test.py::TestDeNovoConstruction::testBAMWholeFile \
      --deselect tests/AlignmentFile_test.py::TestEmptyHeader::testEmptyHeader \
      --deselect tests/AlignmentFile_test.py::TestHeaderWithProgramOptions::testHeader \
      --deselect tests/AlignmentFile_test.py::TestIO::testBAM2BAM \
      --deselect tests/AlignmentFile_test.py::TestIO::testBAM2CRAM \
      --deselect tests/AlignmentFile_test.py::TestIO::testBAM2SAM \
      --deselect tests/AlignmentFile_test.py::TestIO::testFetchFromClosedFileObject \
      --deselect tests/AlignmentFile_test.py::TestIO::testOpenFromFilename \
      --deselect tests/AlignmentFile_test.py::TestIO::testSAM2BAM \
      --deselect tests/AlignmentFile_test.py::TestIO::testWriteUncompressedBAMFile \
      --deselect tests/AlignmentFile_test.py::TestIteratorRowAllBAM::testIterate \
      --deselect tests/StreamFiledescriptors_test.py::StreamTest::test_text_processing \
      --deselect tests/compile_test.py::BAMTest::testCount \
      tests/
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
