{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, mock }:

buildPythonPackage rec {
  pname = "mock-open";
  version = "1.3.2";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "nivbend";
    repo = pname;
    rev = "v${version}";
    sha256 = "08m8mq7wws59zir06b7dzikb6gl6plq3kk2zqrmar6922zcbnk8m";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.3") mock;

  meta = with lib; {
    homepage = "https://github.com/nivbend/mock-open";
    description = "A better mock for file I/O";
    license = licenses.mit;
  };
}
