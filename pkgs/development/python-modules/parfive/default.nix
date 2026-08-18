{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  aiofiles,
  aiohttp,

  # optional dependencies
  aioftp,

  # tests
  pytest-asyncio,
  pytest-localserver,
  pytest-socket,
  pytestCheckHook,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "parfive";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cadair";
    repo = "parfive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i9B860A27KDUJKlE/eQNiGVPEPvnmvmNqMjjdOeBcyY=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    tqdm
  ];

  optional-dependencies = {
    ftp = [ aioftp ];
  };

  nativeCheckInputs = [
    aiofiles
    pytest-asyncio
    pytest-localserver
    pytest-socket
    pytestCheckHook
  ];

  pytestFlags = [
    # https://github.com/Cadair/parfive/issues/65
    "-Wignore::ResourceWarning"
  ];

  disabledTests = [
    # Requires network access
    "test_ftp"
    "test_ftp_pasv_command"
    "test_ftp_http"
    "test_problematic_http_urls"

    # flaky comparison between runtime types
    "test_http_callback_fail"
  ];

  # Tests require local network access
  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # Tests that fail due to network access
    "parfive/tests/test_downloader.py"
    "parfive/tests/test_downloader_multipart.py"
    # assert 1 == 0
    "parfive/tests/test_main.py::test_run_cli_success"
    #  aiohttp.client_exceptions.ClientResponseError: 400, message="Data after `Connection: close
    "parfive/tests/test_utils.py::test_head_or_get"
    "parfive/tests/test_utils.py::test_head_302"
  ];

  pythonImportsCheck = [ "parfive" ];

  meta = {
    description = "HTTP and FTP parallel file downloader";
    mainProgram = "parfive";
    homepage = "https://parfive.readthedocs.io/";
    changelog = "https://github.com/Cadair/parfive/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
