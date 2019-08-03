{ stdenv, buildPythonPackage, fetchFromGitHub, python, robotframework }:

buildPythonPackage rec {
  version = "1.3";
  pname = "robotstatuschecker";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    rev = version;
    sha256 = "0rppwwpp4djn5c43x7icwslnxbzcfnnn3c6awpg1k97j69d2nmln";
  };

  propagatedBuildInputs = [ robotframework ];

  checkPhase = ''
    ${python.interpreter} test/run.py
  '';

  meta = with stdenv.lib; {
    description = "A tool for checking that Robot Framework test cases have expected statuses and log messages";
    homepage = https://github.com/robotframework/statuschecker;
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
