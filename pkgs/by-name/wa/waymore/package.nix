{
  lib,
  fetchFromGitHub,
  python3Packages,
  waymore,
  testers,
}:

python3Packages.buildPythonApplication rec {
  pname = "waymore";
  version = "4.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xnl-h4ck3r";
    repo = "waymore";
    tag = "v${version}";
    hash = "sha256-oaswuXQPdAl2XExwEWnSN15roqNj9OVUr1Y1vsX461o=";
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    termcolor
    pyyaml
    psutil
    uritools
    tldextract
  ];

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
