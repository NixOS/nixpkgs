{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  rns,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = "refs/tags/${version}";
    hash = "sha256-O8uqGo4pgN1xb6/hwEb0B/ymeA9as9/mFj9t9dI4pNg=";
  };

  build-system = [ setuptools ];

  dependencies = [ rns ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "LXMF" ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "lxmd";
  };
}
