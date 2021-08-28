{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, typecode
, patch
, extractcode-libarchive
, extractcode-7z
, pytestCheckHook
, pytest-xdist
}:
buildPythonPackage rec {
  pname = "extractcode";
  version = "21.2.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f91638dbf523b80df90ac184c25d5cd1ea24cac53f67a6bb7d7b389867e0744b";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    typecode
    patch
    extractcode-libarchive
    extractcode-7z
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  # cli test tests the cli which we can't do until after install
  disabledTestPaths = [
    "tests/test_extractcode_cli.py"
  ];

  # test_uncompress_* wants to use a binary to extract instead of the provided library
  disabledTests = [
    "test_uncompress_lz4_basic"
    "test_extract_tarlz4_basic"
  ];

  pythonImportsCheck = [
    "extractcode"
  ];

  meta = with lib; {
    description = "A mostly universal archive extractor using z7zip, libarchve, other libraries and the Python standard library for reliable archive extraction";
    homepage = "https://github.com/nexB/extractcode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
