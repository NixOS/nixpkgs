{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "2.3.5";
  pname = "pydocumentdb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e6f072ae516fc061c9442f8ca470463b53dc626f0f6a86ff3a803293f4b50dd";
  };

  # https://github.com/Azure/azure-cosmos-python/issues/183
  preBuild = ''
    touch changelog.md
  '';

  propagatedBuildInputs = [ six requests ];

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = https://github.com/Azure/azure-cosmos-python;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
