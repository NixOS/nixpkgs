{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-core,
  azure-identity,
  opencensus,
  psutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "opencensus-ext-azure";
  version = "1.1.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ycbrrVQq62GBMyLmJ9WImlY+e4xOAkv1hGnQbbc6sUg=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    maintainers = with maintainers; [
      billhuang
      evilmav
    ];
  };
}
