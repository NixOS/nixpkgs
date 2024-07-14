{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pytankerkoenig";
  version = "0.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IBydKTLqF8ihwSL5EJVtYGYJol6uf4O+O6IMS1R4Lgg=";
  };

  # Tests require an API key and network access
  doCheck = false;
  pythonImportsCheck = [ "pytankerkoenig" ];

  meta = with lib; {
    description = "Python module to get fuel data from tankerkoenig.de";
    homepage = "https://github.com/ultrara1n/pytankerkoenig";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
