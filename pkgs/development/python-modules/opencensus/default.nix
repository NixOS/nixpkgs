{ buildPythonPackage
, fetchPypi
, lib
, unittestCheckHook
, google-api-core
, opencensus-context
}:

buildPythonPackage rec {
  pname = "opencensus";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AmIWq6uJ2U2FBJLz3GWVAFXsT4QRX6bHvq/7pEo0bkI=";
  };

  propagatedBuildInputs = [
    google-api-core
    opencensus-context
  ];

  pythonNamespaces = [
    "opencensus.common"
  ];

  doCheck = false; # No tests in sdist

  pythonImportsCheck = [
    "opencensus.common"
  ];

  meta = with lib; {
    description = "A stats collection and distributed tracing framework";
    homepage = "https://github.com/census-instrumentation/opencensus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
