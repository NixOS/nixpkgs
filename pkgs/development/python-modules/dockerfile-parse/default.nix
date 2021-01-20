{ lib, stdenv, buildPythonPackage, fetchPypi, six, pytestcov, pytest }:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "dockerfile-parse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f37bfa327fada7fad6833aebfaac4a3aaf705e4cf813b737175feded306109e8";
  };

  postPatch = ''
    echo " " > tests/requirements.txt \
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestcov pytest ];

  meta = with lib; {
    description = "Python library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
