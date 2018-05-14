{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, mock }:

buildPythonPackage rec {
  pname = "mock-open";
  version = "1.3.1";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "nivbend";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ikhrhlkl5c7qbigpsv44jw89ws1z7j06gzyg5dh1ki533ifbjm2";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.3") mock;

  meta = with lib; {
    homepage = https://github.com/nivbend/mock-open;
    description = "A better mock for file I/O";
    license = licenses.mit;
  };
}
