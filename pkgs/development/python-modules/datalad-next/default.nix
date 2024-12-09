{
  annexremote,
  buildPythonPackage,
  datalad,
  datasalad,
  fetchFromGitHub,
  git,
  git-annex,
  humanize,
  lib,
  more-itertools,
  psutil,
  pytestCheckHook,
  setuptools,
  openssh,
  unzip,
  versioneer,
  webdavclient3,
}:

buildPythonPackage rec {
  pname = "datalad-next";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datalad-next";
    rev = "refs/tags/${version}";
    hash = "sha256-fqP6nG2ncDRg48kvlsmPjNBOzfQp9+7wTcGvsYVrRzA=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  nativeBuildInputs = [ git ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    annexremote
    datasalad
    datalad
    humanize
    more-itertools
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
    webdavclient3
    psutil
    git-annex
    datalad
    openssh
    unzip
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

    # requires internet access
    "test_push_wanted"
    "test_auto_data_transfer"
    "test_http_url_operations"
    "test_transparent_decompression"
    "test_compressed_file_stay_compressed"
    "test_ls_file_collection_tarfile"
    "test_iter_tar"
  ];

  disabledTestPaths = [
    # requires internet access
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
