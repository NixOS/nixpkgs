{ buildPythonPackage
, fetchPypi
, lib
, unittestCheckHook
, google-api-core
, opencensus-context
}:

buildPythonPackage rec {
  pname = "opencensus";
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YVQEKiNrns3VWiPfuydDuz3qzQaH4+A5HsLgx0lQ1m8=";
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
