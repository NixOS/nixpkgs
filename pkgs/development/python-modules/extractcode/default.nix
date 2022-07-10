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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "extractcode";
  version = "31.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gIGTkum8+BKfdNiQT+ipjA3+0ngjVoQnNygsAoMRPYg=";
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

  # CLI test tests the cli which we can't do until after install
  disabledTestPaths = [
    "tests/test_extractcode_cli.py"
  ];

  # test_uncompress_* wants to use a binary to extract instead of the provided library
  disabledTests = [
    "test_uncompress_lz4_basic"
    "test_extract_tarlz4_basic"
    "test_extract_rar_with_trailing_data"
    # tries to parse /boot/vmlinuz-*, which is not available in the nix sandbox
    "test_can_extract_qcow2_vm_image_as_tarball"
    "test_can_extract_qcow2_vm_image_not_as_tarball"
    "test_can_listfs_from_qcow2_image"
    "test_get_extractor_qcow2"
  ];

  pythonImportsCheck = [
    "extractcode"
  ];

  meta = with lib; {
    description = "Universal archive extractor using z7zip, libarchve, other libraries and the Python standard library";
    homepage = "https://github.com/nexB/extractcode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
