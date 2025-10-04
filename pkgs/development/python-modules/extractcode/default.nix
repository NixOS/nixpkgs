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
  p7zip,
}:

buildPythonPackage rec {
  pname = "extractcode";
  version = "31.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "extractcode";
    tag = "v${version}";
    hash = "sha256-mPHGe/pMaOnIykDd4AjGcvh/T4UrbaGxrSVGhchqYFM=";
  };

  postPatch = ''
    # PEP440 support was removed in newer setuptools, https://github.com/nexB/extractcode/pull/46
    substituteInPlace setup.cfg \
      --replace-fail ">=3.6.*" ">=3.6"
  '';

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  env.EXTRACTCODE_7Z_PATH = "${p7zip}/bin/7z";

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

    # assertion error where files have extra _ or numbers since `p7zip` replacement with `_7zz`
    # suspected cause: not overwriting files
    # tests/test_archive.py
    "test_extract_7zip_with_weird_filenames_with_sevenzip_posix"
    "test_extract_ar_with_weird_filenames_with_sevenzip_posix"
    "test_extract_tar_with_weird_filenames_with_sevenzip_posix"
    "test_extract_cpio_with_weird_filenames_with_sevenzip_posix"
    "test_extract_zip_with_weird_filenames_with_sevenzip_posix"
    # tests/test_sevenzip.py
    "test_extract_file_by_file_weird_names_ar"
    "test_extract_file_by_file_weird_names_cpio"
    "test_extract_file_by_file_weird_names_zip"
    "test_extract_file_by_file_weird_names_tar"
    "test_extract_file_by_file_with_weird_names_7z"

    # other changes since `p7zip` replacement with `_7zz`
    # AssertionError: assert not 'Unknown extraction error'
    "test_list_zip_with_relative_path_deeply_nested_with_7zip"
    # AssertionError: Exception not raised
    "test_extract_cpio_broken_7z"
    # TypeError: can only concatenate list (not "str") to list
    "test_list_entries_of_special_tar"
    # TypeError: can only concatenate list (not "str") to list
    "test_list_entries_with_weird_names_7z"
  ];

  pythonImportsCheck = [ "extractcode" ];

  meta = {
    description = "Universal archive extractor using z7zip, libarchive, other libraries and the Python standard library";
    homepage = "https://github.com/aboutcode-org/extractcode";
    changelog = "https://github.com/aboutcode-org/extractcode/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "extractcode";
  };
}
