{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  extractcode-7z,
  extractcode-libarchive,
  patch,
  six,
  typecode,

  # tests
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "extractcode";
  version = "31.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "extractcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KTLhTvTn5awIJD32lsztm6nh15eoFew1mGJvHIT8H2U=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [
    extractcode-7z
    extractcode-libarchive
    patch
    six
    typecode
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
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
    # extractcode.libarchive2.ArchiveErrorRetryable: Damaged tar archive
    "test_extract_python_testtar_tar_archive_with_special_files"
    # AssertionError: [<function extract at 0x7ffff493dd00>] == [] for archive/rar/basic.rar
    "test_get_extractors_2"
    # assert [functools.pa...ffff452df80>)] == []
    "test_windows_media_player_skins_are_zip"
    # AssertionError: assert Handler(name='Nuget', filetypes=('zip archive', 'mic...
    "test_get_best_handler_nuget_is_selected_over_zip"
    "test_get_best_handler_nuget_is_selected_over_zip2"
    "test_get_best_handler_nuget_is_selected_over_zip3"
  ];

  pythonImportsCheck = [ "extractcode" ];

  meta = {
    description = "Universal archive extractor using z7zip, libarchive, other libraries and the Python standard library";
    homepage = "https://github.com/aboutcode-org/extractcode";
    changelog = "https://github.com/aboutcode-org/extractcode/releases/tag/v${finalAttrs.version}";
    mainProgram = "extractcode";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
