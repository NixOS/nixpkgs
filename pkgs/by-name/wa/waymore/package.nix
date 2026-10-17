{
  lib,
  fetchFromGitHub,
  python3Packages,
  waymore,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "waymore";
  version = "8.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xnl-h4ck3r";
    repo = "waymore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-niV9aqBlSz9bkMF9uI34bmlm7Mqg3cDZGjjrtGN01Xk=";
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
    version = "Waymore - v${finalAttrs.version}";
  };

  meta = {
    description = "Find way more from the Wayback Machine";
    homepage = "https://github.com/xnl-h4ck3r/waymore";
    changelog = "https://github.com/xnl-h4ck3r/waymore/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "waymore";
  };
})
