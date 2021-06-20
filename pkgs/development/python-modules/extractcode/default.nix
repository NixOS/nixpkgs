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
  version = "21.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e665501438fedeb6e75335d880c8913a8cd894fd8adcf9c243eb6d48fad2d01c";
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
    # tries to parse /boot/vmlinuz-*, which is not available in the nix sandbox
    "test_can_extract_qcow2_vm_image_as_tarball"
    "test_can_extract_qcow2_vm_image_not_as_tarball"
    "test_can_listfs_from_qcow2_image"
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
