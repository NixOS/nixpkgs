{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  blinker,
  cloudpickle,
  dill,
  h5py,
  matplotlib,
  msgpack,
  numpy,
  plotly,
  python-socketio,
  scipy,
  uncertainties,

  # testing
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "bumps";
  version = "1.0.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bumps";
    repo = "bumps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s+SZRH53R5itCUww+lCxk7iEm4tgZcGkvIDyI12fKcY=";
  };

  postPatch = ''
    # Upstream uses versioningit to set the version
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["setuptools", "versioningit"]' 'requires = ["setuptools"]'
    sed -i '/^name =.*/a version = "${finalAttrs.version}"' pyproject.toml
    sed -i "/dynamic =/d" pyproject.toml
  '';

  pythonRemoveDeps = [
    "mpld3" # not packaged
  ];

  build-system = [
    setuptools
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
    python-socketio
    scipy
    uncertainties
    # mpld3 # not packaged
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "bumps" ];

  meta = {
    description = "Data fitting with bayesian uncertainty analysis";
    mainProgram = "bumps";
    homepage = "https://bumps.readthedocs.io/";
    changelog = "https://github.com/bumps/bumps/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
})
