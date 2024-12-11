{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  regex,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysuez";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jb101010-2";
    repo = "pySuez";
    rev = "refs/tags/${version}";
    hash = "sha256-+pLknJDF0SsC6OsmP64D/yZeu0sGNtKo8EBGlDewBug=";
  };

  build-system = [ setuptools ];

  dependencies = [
    regex
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysuez" ];

  meta = with lib; {
    description = "Module to get water consumption data from Suez";
    mainProgram = "pysuez";
    homepage = "https://github.com/jb101010-2/pySuez";
    changelog = "https://github.com/jb101010-2/pySuez/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
