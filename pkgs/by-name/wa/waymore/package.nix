{
  lib,
  fetchFromGitHub,
  python3Packages,
  waymore,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "waymore";
  version = "8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xnl-h4ck3r";
    repo = "waymore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mis0QbXWNre5H7VyXz6HzgArgQV0AdjUjZDQM+y3j0c=";
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # Allow version test
  postPatch = ''
    substituteInPlace waymore/waymore.py \
      --replace-fail 'if (sys.stdout.isatty() or (not sys.stdout.isatty() and pipe))' \
                'if (sys.stdout.isatty() or (not sys.stdout.isatty() and (pipe or "--version" in sys.argv)))'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRemoveDeps = [
    # python already provides urllib.parse
    "urlparse3"
  ];

  dependencies = with python3Packages; [
    aiohttp
    psutil
    pyyaml
    requests
    termcolor
    tldextract
  ];

  pythonImportsCheck = [ "waymore.waymore" ];

  passthru.tests.version = testers.testVersion {
    package = waymore;
    command = "waymore --version";
    version = "${finalAttrs.version}";
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
