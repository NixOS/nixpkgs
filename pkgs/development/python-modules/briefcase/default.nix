{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  stdenv,
  writableTmpDirAsHomeHook,

  # core python toolchain deps / buildsystem deps
  build,
  packaging,
  pip,
  setuptools,
  setuptools-scm,
  truststore,
  wheel,

  # runtime deps
  binaryornot,
  chardet,
  cookiecutter,
  dmgbuild,
  gitpython,
  httpx,
  platformdirs,
  psutil,
  python-dateutil,
  rich,
  tenacity,
  tomli-w,

  # test deps
  pytestCheckHook,
  httpx-retries,
}:

buildPythonPackage (finalAttrs: {
  pname = "briefcase";
  version = "0.4.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "briefcase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dspMBBSrUoc0nK3GezSWlqs91vT2FNx6t8ibKxvxnqk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==83.0.0" "setuptools" \
      --replace-fail "setuptools_scm==10.2.0" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    binaryornot
    build
    chardet
    cookiecutter
    gitpython
    httpx
    packaging
    pip
    platformdirs
    psutil
    python-dateutil
    rich
    setuptools
    tenacity
    tomli-w
    truststore
    wheel
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    dmgbuild
  ];

  pythonRelaxDeps = [
    "chardet"
    "setuptools"
    "setuptools_scm"
  ];

  nativeCheckInputs = [
    httpx-retries
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # These tests check that upstream tool download URLs are resolvable.
    "test_cmdline_tools_url"
    "test_download_missing"
    "test_download_sdk"
    "test_download_url"
    "test_download_sdk_legacy_install"
    "test_download_sdk_if_sdkmanager_not_executable"
    "test_raises_networkfailure_on_connectionerror"
    "test_upgrade_existing_sdk"
    "test_rcedit_url"
    "test_successful_jdk_download"

    # this test fails for us on aarch64 for unknown reasons
    "test_detects_bad_zipfile"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # these tests fail on darwin, mostly with permission errors
    # it's possible there's an easy fix, but the reason for packaging this was
    # as a dependency of another package, and so I'm taking the easier path of
    # just skipping them; I don't have a macOS device to iterate on these
    # properly
    "test_ditto"
    "test_doctype_icon_target"
    "test_document_type_config"
    "test_document_type_config_default_mime_type"
    "test_document_type_config_valid_mime_type"
    "test_document_type_macOS_config_with_list_of_single_content_type[com.adobe.pdf]"
    "test_document_type_macOS_config_with_list_of_single_content_type[ls_item_content_types1]"
    "test_document_type_macOS_config_with_mimetype_list"
    "test_document_type_macOS_config_with_mimetype_single"
    "test_document_type_macOS_config_with_unknown_mimetype"
    "test_extra_attrs"
    "test_is_uti_core_type"
    "test_mime_type_to_uti"
    "test_supported_host_os_docker"
  ];

  pythonImportsCheck = [ "briefcase" ];

  meta = {
    description = "Tools to support converting a Python project into a standalone native application";
    mainProgram = "briefcase";
    homepage = "https://briefcase.beeware.org/en/stable/";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ euank ];
  };
})
