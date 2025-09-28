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

  postPatch = ''
    # https://github.com/robotframework/statuschecker/issues/46
    substituteInPlace test/tests.robot \
      --replace-fail BuiltIn.Log Log
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ robotframework ];

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
