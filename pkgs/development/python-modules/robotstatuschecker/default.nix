{ lib, buildPythonPackage, fetchFromGitHub, python, robotframework }:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "robotstatuschecker";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-7xHPqlR7IFZp3Z120mg25ZSg9eI878kE8RF1y3F5O70=";
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
