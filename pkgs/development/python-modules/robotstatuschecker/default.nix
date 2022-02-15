{ lib, buildPythonPackage, fetchFromGitHub, python, robotframework }:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "robotstatuschecker";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    rev = version;
    sha256 = "0hy1390j3l4kkfna9x9xax4y5mqaa3hdndv3fiyg9wr5f7sx3wnz";
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
