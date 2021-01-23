{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyxeoma";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c9q6xdh2ciisv0crlz069haz01gfkhd5kasyr14jng4vjpzinc7";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project doesn't have any tests
  doCheck = false;
  pythonImportsCheck = [ "pyxeoma" ];

  meta = with lib; {
    description = "Python wrapper for Xeoma web server API";
    homepage = "https://github.com/jeradM/pyxeoma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
