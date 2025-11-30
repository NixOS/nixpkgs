{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  azure-core,
  azure-identity,
  opencensus,
  psutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "opencensus-ext-azure";
  version = "1.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "census-instrumentation";
    repo = "opencensus-python";
    tag = "opencensus-ext-azure@${version}";
    hash = "sha256-fnqflSyNnkEy9XYoirk4iDZI1zYTRMbrYMyQ/4ge3Rs=";
  };

  sourceRoot = "${src.name}/contrib/opencensus-ext-azure";

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
