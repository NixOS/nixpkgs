{
  lib,
  fetchPypi,
  buildPythonPackage,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "pylpsd";
  version = "0.1.4";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-evPL9vF75S8ATkFwzQjh4pLI/aXGXWwoypCb24nXAN8=";
  };

  # Tests fail and there are none
  doCheck = false;
  pythonImportsCheck = [ "pylpsd" ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  meta = with lib; {
    description = "Python implementation of the LPSD algorithm for computing power spectral density with logarithmically spaced points.";
    homepage = "https://github.com/bleykauf/py-lpsd";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
