{ lib
, buildPythonPackage
, fetchPypi
, requests
, simplejson
, fake-useragent
}:

buildPythonPackage rec {
  pname = "pyatome";
  version = "0.1.2";

  src = fetchPypi {
    pname = "pyAtome";
    inherit version;
    sha256 = "sha256-DGkgW6emh/esZa/alUjBbpLXlU4EVIPkysn9a0LgcJ4=";
  };

  propagatedBuildInputs = [ requests simplejson fake-useragent ];

  # no tests  in PyPI tarballs
  doCheck = false;

  pythonImportsCheck = [
    "pyatome"
  ];

  meta = with lib; {
    description = "Python module to get energy consumption data from Atome";
    homepage = "https://github.com/baqs/pyAtome";
    license = licenses.asl20;
    maintainers = with maintainers; [ uvnikita ];
  };
}
