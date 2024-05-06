{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csdr-lu,
}:

buildPythonPackage rec {
  pname = "pycsdr";

  version = "0.18.29-lu";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr";
    rev = "7cfc6089305b054a5c0c8db404d3cb3ebbcb4513";
    hash = "sha256-I43hmOZagzqXE45gUszi/nAWHL/cp2kE//knNIXJnyU=";
  };

  propagatedBuildInputs = [ csdr-lu ];

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
