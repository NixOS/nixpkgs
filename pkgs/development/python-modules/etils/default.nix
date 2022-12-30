{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core

  # tests
, chex
, jaxlib
, pytest-subtests
, pytest-xdist
, pytestCheckHook
, yapf

  # optional
, jupyter
, mediapy
, numpy
, importlib-resources
, typing-extensions
, zipp
, absl-py
, tqdm
, dm-tree
, jax
, tensorflow
}:

buildPythonPackage rec {
  pname = "etils";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SJED6eSZpWZ2XGBFjuFdGFzwBl8gYKTRamj49Gli7Q0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  passthru.optional-dependencies = rec {
    array-types = enp;
    ecolab = [ jupyter numpy mediapy ] ++ enp ++ epy;
    edc = epy;
    enp = [ numpy ] ++ epy;
    epath = [ importlib-resources typing-extensions zipp ] ++ epy;
    epy = [ typing-extensions ];
    etqdm = [ absl-py tqdm ] ++ epy;
    etree = array-types ++ epy ++ enp ++ etqdm;
    etree-dm = [ dm-tree ] ++ etree;
    etree-jax = [ jax ] ++ etree;
    etree-tf = [ tensorflow etree ] ++ etree;
    all = array-types ++ ecolab ++ edc ++ enp ++ epath ++ epy ++ etqdm
      ++ etree ++ etree-dm ++ etree-jax ++ etree-tf;
  };

  pythonImportsCheck = [
    "etils"
  ];

  checkInputs = [
    chex
    jaxlib
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    yapf
  ]
  ++ passthru.optional-dependencies.all;

  disabledTests = [
    "test_repr" # known to fail on Python 3.10, see https://github.com/google/etils/issues/143
    "test_public_access" # requires network access
    "test_resource_path" # known to fail on Python 3.10, see https://github.com/google/etils/issues/143
  ];

  doCheck = false; # error: infinite recursion encountered

  meta = with lib; {
    description = "Collection of eclectic utils for python";
    homepage = "https://github.com/google/etils";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
