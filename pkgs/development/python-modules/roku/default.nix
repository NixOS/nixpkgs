{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  requests,
  pytest,
  flask,
}:

buildPythonPackage rec {
  version = "4.1";
  format = "setuptools";
  pname = "roku";

  src = fetchFromGitHub {
    owner = "jcarbaugh";
    repo = "python-roku";
    rev = "v${version}";
    hash = "sha256-R318J3uVL3HHLn/pkhplp2pmg0gME551kO9QKmcquCY=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytest
    flask
  ];
  pythonImportsCheck = [ "roku" ];

  meta = {
    description = "Screw remotes. Control your Roku with Python";
    homepage = "https://github.com/jcarbaugh/python-roku";
    license = lib.licenses.bsd3;
  };
}
