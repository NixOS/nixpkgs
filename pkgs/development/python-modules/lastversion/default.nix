{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # nativeBuildInputs
  setuptools,
  # nativeCheckInputs
  pytestCheckHook,
  # install_requires
  appdirs,
  beautifulsoup4,
  cachecontrol,
  distro,
  feedparser,
  packaging,
  python-dateutil,
  pyyaml,
  requests,
  tqdm,
  urllib3,
}:

buildPythonPackage rec {
  pname = "lastversion";
  version = "3.5.7";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dvershinin";
    repo = "lastversion";
    tag = "v${version}";
    hash = "sha256-z3QrtnhIgXLVyaDNm0XqaVqZb05K3pq8mbweTpphdBQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    beautifulsoup4
    cachecontrol
    distro
    feedparser
    packaging
    python-dateutil
    pyyaml
    requests
    tqdm
    urllib3
  ]
  ++ cachecontrol.optional-dependencies.filecache;

  pythonRelaxDeps = [
    "cachecontrol" # Use newer cachecontrol that uses filelock instead of lockfile
    "urllib3" # The cachecontrol and requests incompatibility issue is closed
  ];

  pythonRemoveDeps = [
    "lockfile" # "cachecontrol" now uses filelock
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    "tests/test_cli.py"
  ];

  enabledTests = [
    "test_cli_format"
  ];

  # CLI tests expect the output bin/ in PATH
  preCheck = ''
    PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "lastversion" ];

  meta = {
    description = "Find the latest release version of an arbitrary project";
    homepage = "https://github.com/dvershinin/lastversion";
    changelog = "https://github.com/dvershinin/lastversion/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "lastversion";
  };
}
