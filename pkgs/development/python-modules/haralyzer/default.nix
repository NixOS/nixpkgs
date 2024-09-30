{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "haralyzer";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "haralyzer";
    repo = "haralyzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-4Q0kNorZwE1zvh768sLRgIP4vRvI1Ide3uSfzqL5oIU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-dateutil
  ];

  meta = {
    changelog = "https://github.com/haralyzer/haralyzer/releases/tag/${version}";
    description = "A Framework For Using HAR Files To Analyze Web Pages";
    homepage = "https://github.com/haralyzer/haralyzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ riotbib ];
  };
}
