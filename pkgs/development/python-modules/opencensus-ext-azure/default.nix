{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-core
, azure-identity
, opencensus
, psutil
, requests
}:

buildPythonPackage rec {
  pname = "opencensus-ext-azure";
  version = "1.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UHYIt36djqq2/9X/EbfOuH9U5KapQMS4FDMbTRsDQVE=";
  };

  propagatedBuildInputs = [
    azure-core
    azure-identity
    opencensus
    psutil
    requests
  ];

  pythonImportsCheck = [ "opencensus.ext.azure" ];

  doCheck = false; # tests are not included in the PyPi tarball

  meta = with lib; {
    homepage = "https://github.com/census-instrumentation/opencensus-python/tree/master/contrib/opencensus-ext-azure";
    description = "OpenCensus Azure Monitor Exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang evilmav ];
  };
}
