{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  versioningit,
  numpy,
  scipy,
  h5py,
  dill,
  matplotlib,
  blinker,
  aiohttp,
  python,
  plotly,
  python-socketio,
}:

buildPythonPackage rec {
  pname = "bumps";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YfnBA1rCD05B4XOS611qgi4ab3xKoYs108mwhj/I+sg=";
  };

  pythonRemoveDeps = [
    "mpld3" # not packaged
  ];

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
    numpy
    scipy
    h5py
    dill
    matplotlib
    blinker
    aiohttp
    python
    plotly
    python-socketio
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
