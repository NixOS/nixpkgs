{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  simplejson,
  fake-useragent,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyatome";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyAtome";
    inherit version;
    hash = "sha256-DGkgW6emh/esZa/alUjBbpLXlU4EVIPkysn9a0LgcJ4=";
  };

  propagatedBuildInputs = [
    requests
    simplejson
    fake-useragent
  ];

  # No tests in PyPI tarballs
  doCheck = false;

  pythonImportsCheck = [ "pyatome" ];

  meta = with lib; {
    description = "Python module to get energy consumption data from Atome";
    mainProgram = "pyatome";
    homepage = "https://github.com/baqs/pyAtome";
    license = licenses.asl20;
    maintainers = with maintainers; [ uvnikita ];
  };
}
