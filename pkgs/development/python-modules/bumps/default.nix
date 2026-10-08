{
  lib,
  aiohttp,
  blinker,
  buildPythonPackage,
  cloudpickle,
  dill,
  fetchPypi,
  h5py,
  matplotlib,
  msgpack,
  numpy,
  plotly,
  python-socketio,
  python,
  scipy,
  setuptools,
  versioningit,
}:

buildPythonPackage rec {
  pname = "bumps";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O5GUoyDlB0X2Z/O3JprN3omoOBDIhv0xrKfUSHTgGpM=";
  };

  pythonRemoveDeps = [
    "mpld3" # not packaged
  ];

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
    aiohttp
    blinker
    cloudpickle
    dill
    h5py
    matplotlib
    msgpack
    numpy
    plotly
    python
    python-socketio
    scipy
    # mpld3 # not packaged
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "bumps" ];

  meta = {
    description = "Data fitting with bayesian uncertainty analysis";
    mainProgram = "bumps";
    homepage = "https://bumps.readthedocs.io/";
    changelog = "https://github.com/bumps/bumps/releases/tag/v${version}";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
