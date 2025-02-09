{ lib, buildPythonPackage, fetchFromGitHub, csdr }:

buildPythonPackage rec {
  pname = "pycsdr";
  version = "0.18.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "pycsdr";
    rev = version;
    hash = "sha256-OyfcXCcbvOOhBUkbAba3ayPzpH5z2nJWHbR6GcrCMy8=";
  };

  propagatedBuildInputs = [ csdr ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = {
    homepage = "https://github.com/jketterl/pycsdr";
    description = "bindings for the csdr library";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.c3d2.members;
  };
}
