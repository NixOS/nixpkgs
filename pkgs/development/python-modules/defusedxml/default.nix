{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  python,
}:

buildPythonPackage rec {
  pname = "defusedxml";
  version = "0.8.0rc2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiran";
    repo = "defusedxml";
    rev = "refs/tags/v${version}";
    hash = "sha256-X88A5V9uXP3wJQ+olK6pZJT66LP2uCXLK8goa5bPARA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ lxml ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "defusedxml" ];

  meta = with lib; {
    changelog = "https://github.com/tiran/defusedxml/blob/v${version}/CHANGES.txt";
    description = "Python module to defuse XML issues";
    homepage = "https://github.com/tiran/defusedxml";
    license = licenses.psfl;
    maintainers = with maintainers; [ fab ];
  };
}
