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
  version = "30.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a660d1b9e3bae4aa87828e6947dc3b31dc2fa6705acb28a514874602b40bc90";
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
