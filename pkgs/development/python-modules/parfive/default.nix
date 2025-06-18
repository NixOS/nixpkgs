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

buildPythonPackage rec {
  pname = "parfive";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Cadair";
    repo = "parfive";
    tag = "v${version}";
    hash = "sha256-DIjS2q/SOrnLspomLHk8ZJ+krdzMyQfbIpXxad30s1k=";
  };

  pyproject = true;

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

  disabledTests = [
    # Requires network access
    "test_ftp"
    "test_ftp_pasv_command"
    "test_ftp_http"

    # flaky comparison between runtime types
    "test_http_callback_fail"
  ];

  # Tests require local network access
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "parfive" ];

  meta = {
    description = "HTTP and FTP parallel file downloader";
    mainProgram = "parfive";
    homepage = "https://parfive.readthedocs.io/";
    changelog = "https://github.com/Cadair/parfive/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
