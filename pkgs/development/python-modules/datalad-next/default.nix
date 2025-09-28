{
  lib,
  annexremote,
  buildPythonPackage,
  datalad,
  datasalad,
  distutils,
  fetchFromGitHub,
  git-annex,
  git,
  hatch-vcs,
  hatchling,
  humanize,
  more-itertools,
  openssh,
  psutil,
  pytestCheckHook,
  pythonAtLeast,
  requests-toolbelt,
  requests,
  unzip,
  webdavclient3,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "datalad-next";
  version = "1.6.0-unstable-2025-07-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datalad-next";
    rev = "2d2b1526c1e396964dd3ffdbb37597adefe7682d";
    hash = "sha256-47cRxaxOGzR6hDfiW2hS3MNHp2aP9rxtWNxV+33PPfs=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "1.6.0";

  nativeBuildInputs = [ git ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    annexremote
    datasalad
    datalad
    humanize
    more-itertools
  ];

  optional-dependencies = {
    httpsupport = [
      requests
      requests-toolbelt
    ];
  };

  nativeCheckInputs = [
    datalad
    git-annex
    openssh
    psutil
    pytestCheckHook
    unzip
    webdavclient3
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # remotes available after datalad-next install (through `console_scripts`), but not yet in $PATH during test
    "test_uncurl_addurl_unredirected"
    "test_uncurl"
    "test_uncurl_ria_access"
    "test_uncurl_store"
    "test_uncurl_remove"
    "test_uncurl_testremote"
    "test_replace_add_archive_content"
    "test_annex_remote"
    "test_export_remote"
    "test_annex_remote_autorepush"
    "test_export_remote_autorepush"
    "test_typeweb_annex"
    "test_typeweb_annex_uncompressed"
    "test_typeweb_export"
    "test_submodule_url"
    "test_uncurl_progress_reporting_to_annex"
    "test_archivist_retrieval"
    "test_archivist_retrieval_legacy"

    # hardcoded /bin path
    "test_auto_if_wanted_data_transfer_path_restriction"

    # Test require internet access
    "test_auto_data_transfer"
    "test_compressed_file_stay_compressed"
    "test_delete_method"
    "test_delete_timeout"
    "test_http_url_operations"
    "test_iter_tar"
    "test_ls_file_collection_tarfile"
    "test_push_wanted"
    "test_transparent_decompression"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # RuntimeError
    "test_tree_with_broken_symlinks"
  ];

  disabledTestPaths = [
    # Tests require internet access
    "datalad_next/commands/tests/test_download.py"
    "datalad_next/archive_operations/tests/test_tarfile.py"
  ];

  pythonImportsCheck = [ "datalad_next" ];

  meta = {
    description = "DataLad extension with a staging area for additional functionality, or for improved performance and user experience";
    changelog = "https://github.com/datalad/datalad-next/blob/main/CHANGELOG.md";
    homepage = "https://github.com/datalad/datalad-next";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
