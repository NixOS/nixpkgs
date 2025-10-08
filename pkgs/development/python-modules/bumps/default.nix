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
  pythonOlder,
  scipy,
  setuptools,
  versioningit,
}:

buildPythonPackage rec {
  pname = "bumps";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Data fitting with bayesian uncertainty analysis";
    mainProgram = "bumps";
    homepage = "https://bumps.readthedocs.io/";
    changelog = "https://github.com/bumps/bumps/releases/tag/v${version}";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rprospero ];
  };
}
