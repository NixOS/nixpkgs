{
  lib,
  fetchFromGitHub,
  python3Packages,
  waymore,
  testers,
}:

python3Packages.buildPythonApplication rec {
  pname = "waymore";
  version = "6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xnl-h4ck3r";
    repo = "waymore";
    tag = "v${version}";
    hash = "sha256-3nvdbQydtnk/tod2WyJLAGKKjwTv6Z6JA7+qwqgp2o4=";
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRemoveDeps = [
    # python already provides urllib.parse
    "urlparse3"
  ];

  dependencies = with python3Packages; [
    requests
    termcolor
    pyyaml
    psutil
    uritools
    tldextract
  ];

  pythonImportsCheck = [ "waymore.waymore" ];

  passthru.tests.version = testers.testVersion {
    package = waymore;
    command = "waymore --version";
    version = "Waymore - v${version}";
  };

  meta = {
    description = "Find way more from the Wayback Machine";
    homepage = "https://github.com/xnl-h4ck3r/waymore";
    changelog = "https://github.com/xnl-h4ck3r/waymore/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "waymore";
  };
}
