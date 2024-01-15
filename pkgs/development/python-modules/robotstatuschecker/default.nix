{ lib, buildPythonPackage, fetchFromGitHub, python, robotframework }:

buildPythonPackage rec {
  version = "3.0.1";
  format = "setuptools";
  pname = "robotstatuschecker";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-yW6353gDwo/IzoWOB8oelaS6IUbvTtwwDT05yD7w6UA=";
  };

  propagatedBuildInputs = [ robotframework ];

  checkPhase = ''
    ${python.interpreter} test/run.py
  '';

  meta = with lib; {
    description = "A tool for checking that Robot Framework test cases have expected statuses and log messages";
    homepage = "https://github.com/robotframework/statuschecker";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
