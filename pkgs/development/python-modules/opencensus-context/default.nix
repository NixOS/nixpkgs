{ buildPythonPackage
, fetchPypi
, lib
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "opencensus-context";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oDEIw8ENjIC7Xd9cih8DMWH6YZcqmRf5ubOhhRfwCIw=";
  };

  pythonNamespaces = [
    "opencensus.common"
  ];

  doCheck = false; # No tests in archive

  meta = with lib; {
    description = "OpenCensus Runtime Context";
    homepage = "https://github.com/census-instrumentation/opencensus-python/tree/master/context/opencensus-context";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
