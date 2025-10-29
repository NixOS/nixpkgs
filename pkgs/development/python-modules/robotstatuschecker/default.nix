{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  robotframework,
  python,
}:

buildPythonPackage rec {
  pname = "robotstatuschecker";
  version = "4.1.1";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    tag = "v${version}";
    hash = "sha256-YyiGd3XSIe+4PEL2l9LYDGH3lt1iRAAJflcBGYXaBzY=";
  };

  build-system = [ setuptools ];

  dependencies = [ robotframework ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} test/run.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Tool for checking that Robot Framework test cases have expected statuses and log messages";
    homepage = "https://github.com/robotframework/statuschecker";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
