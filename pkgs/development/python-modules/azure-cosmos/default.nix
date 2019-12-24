{ buildPythonPackage
, lib
, python
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "azure-cosmos";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1955kpn2y16k5mil90bnnyscnh1hyh4d5l5v5b90ms969p61i9zl";
  };

  propagatedBuildInputs = [ six requests ];

  postInstall = ''
    rm $out/${python.sitePackages}/azure/__init__.py
  '';

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = https://github.com/Azure/azure-cosmos-python;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
