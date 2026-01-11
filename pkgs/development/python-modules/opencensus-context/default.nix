{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "opencensus-context";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oDEIw8ENjIC7Xd9cih8DMWH6YZcqmRf5ubOhhRfwCIw=";
  };

  pythonNamespaces = [ "opencensus.common" ];

  doCheck = false; # No tests in archive

  meta = {
    description = "OpenCensus Runtime Context";
    homepage = "https://github.com/census-instrumentation/opencensus-python/tree/master/context/opencensus-context";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
  };
}
