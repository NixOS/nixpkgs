{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  gdsfactory,
  pint,
  tqdm,
  numpy,
  xarray,
}:
buildPythonPackage rec {
  pname = "gplugins";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "gplugins";
    tag = "v${version}";
    hash = "sha256-mA89ufi0zXWVpbIPwbYESXEt6LBDycPIwTK7hvgDCkM=";
  };

  build-system = [ flit-core ];

  dependencies = [
    gdsfactory
    pint
    tqdm
    numpy
    xarray
  ];

  pythonRelaxDeps = [
    "numpy"
    "xarray"
  ];

  # tests require >32GB of RAM
  doCheck = false;

  pythonImportsCheck = [ "gplugins" ];

  meta = {
    description = "GDSFactory plugins";
    homepage = "https://github.com/gdsfactory/gplugins";
    changelog = "https://github.com/gdsfactory/gplugins/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
