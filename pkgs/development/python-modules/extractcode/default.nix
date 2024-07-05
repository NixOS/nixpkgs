{
  lib,
  buildPythonPackage,
  extractcode-7z,
  extractcode-libarchive,
  fetchPypi,
  patch,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  six,
  typecode,
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

  postPatch = ''
    # PEP440 support was removed in newer setuptools, https://github.com/nexB/extractcode/pull/46
    substituteInPlace setup.cfg \
      --replace ">=3.6.*" ">=3.6"
  '';

  dontConfigure = true;

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    typecode
    patch
    extractcode-libarchive
    extractcode-7z
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTestPaths = [
    # CLI test tests the CLI which we can't do until after install
    "tests/test_extractcode_cli.py"
  ];

  disabledTests = [
    # test_uncompress_* wants to use a binary to extract instead of the provided library
    "test_uncompress_lz4_basic"
    "test_extract_tarlz4_basic"
    "test_extract_rar_with_trailing_data"
    # Tries to parse /boot/vmlinuz-*, which is not available in the nix sandbox
    "test_can_extract_qcow2_vm_image_as_tarball"
    "test_can_extract_qcow2_vm_image_not_as_tarball"
    "test_can_listfs_from_qcow2_image"
    "test_get_extractor_qcow2"
    # WARNING  patch:patch.py:450 inconsistent line ends in patch hunks
    "test_patch_info_patch_patches_windows_plugin_explorer_patch"
    # AssertionError: assert [['linux-2.6...._end;', ...]]] == [['linux-2.6...._end;', ...]]]
    "test_patch_info_patch_patches_misc_linux_st710x_patches_motorola_rootdisk_c_patch"
  ];

  pythonImportsCheck = [ "extractcode" ];

  meta = with lib; {
    description = "Universal archive extractor using z7zip, libarchive, other libraries and the Python standard library";
    mainProgram = "extractcode";
    homepage = "https://github.com/nexB/extractcode";
    changelog = "https://github.com/nexB/extractcode/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
