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
  version = "3.0.1";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-yW6353gDwo/IzoWOB8oelaS6IUbvTtwwDT05yD7w6UA=";
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
    description = "A tool for checking that Robot Framework test cases have expected statuses and log messages";
    homepage = "https://github.com/robotframework/statuschecker";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
