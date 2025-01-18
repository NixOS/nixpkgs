{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "devgoldyutils";
  version = "3.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2kGu9QPP5WqKv2gO9DAkE9SNDerzNaEDRt5DrrYD9nQ=";
  };

  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "devgoldyutils" ];

  meta = with lib; {
    description = "Collection of utility functions for Python used by mov-cli";
    homepage = "https://github.com/THEGOLDENPRO/devgoldyutils";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ youhaveme9 ];
  };
}
