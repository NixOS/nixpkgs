{ lib
, buildPythonPackage
, fetchPypi
, requests
, simplejson
, fake-useragent
}:

buildPythonPackage rec {
  pname = "pyatome";
  version = "0.1.1";

  src = fetchPypi {
    pname = "pyAtome";
    inherit version;
    sha256 = "7282e7ec258c69d4ddf2a5754ff07680a1ac92f9bfb478d601fd9e944fccd834";
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
