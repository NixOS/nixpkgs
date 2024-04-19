{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "objprint";
  version = "0.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gaogaotiantian";
    repo = "objprint";
    rev = "${version}";
    hash = "sha256-IGYjDdi3JzYk53ITVOhVnm9EDsa+4HXSVtVUE3wQWTo=";
  };

  # Extract the specific subdirectory within the repository
  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/gaogaotiantian/objprint";
    description = "A library that can print Python objects in human readable format";
    license = licenses.asl20;
  };
}
