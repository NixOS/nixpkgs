{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,

  # tests
  chex,
  jaxlib,
  pytest-subtests,
  pytest-xdist,
  pytestCheckHook,
  yapf,

  # optional
  jupyter,
  mediapy,
  numpy,
  importlib-resources,
  typing-extensions,
  zipp,
  absl-py,
  tqdm,
  dm-tree,
  jax,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "etils";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tqqdckj9Tut15E1HyimHWlzOoETMFKF0NXlL+KwRagU=";
  };

  nativeBuildInputs = [ flit-core ];

  optional-dependencies = rec {
    array-types = enp;
    eapp = [
      absl-py # FIXME package simple-parsing
    ] ++ epy;
    ecolab = [
      jupyter
      numpy
      mediapy
    ] ++ enp ++ epy;
    edc = epy;
    enp = [ numpy ] ++ epy;
    epath = [
      importlib-resources
      typing-extensions
      zipp
    ] ++ epy;
    epy = [ typing-extensions ];
    etqdm = [
      absl-py
      tqdm
    ] ++ epy;
    etree = array-types ++ epy ++ enp ++ etqdm;
    etree-dm = [ dm-tree ] ++ etree;
    etree-jax = [ jax ] ++ etree;
    etree-tf = [ tensorflow ] ++ etree;
    all =
      array-types
      ++ eapp
      ++ ecolab
      ++ edc
      ++ enp
      ++ epath
      ++ epy
      ++ etqdm
      ++ etree
      ++ etree-dm
      ++ etree-jax
      ++ etree-tf;
  };

  pythonImportsCheck = [ "etils" ];

  nativeCheckInputs = [
    chex
    jaxlib
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    yapf
  ] ++ optional-dependencies.all;

  disabledTests = [
    "test_public_access" # requires network access
  ];

  doCheck = false; # error: infinite recursion encountered

  meta = with lib; {
    changelog = "https://github.com/google/etils/blob/v${version}/CHANGELOG.md";
    description = "Collection of eclectic utils";
    homepage = "https://github.com/google/etils";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
