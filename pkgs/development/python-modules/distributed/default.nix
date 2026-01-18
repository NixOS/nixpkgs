{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  click,
  cloudpickle,
  dask,
  jinja2,
  locket,
  msgpack,
  packaging,
  psutil,
  pyyaml,
  sortedcontainers,
  tblib,
  toolz,
  tornado,
  urllib3,
  zict,
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "2026.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "distributed";
    tag = version;
    hash = "sha256-xriIsrdFNSHAO9SmdowXK9uPW06ziz9uGie3PkYncqo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "dask" ];

  dependencies = [
    click
    cloudpickle
    dask
    jinja2
    locket
    msgpack
    packaging
    psutil
    pyyaml
    sortedcontainers
    tblib
    toolz
    tornado
    urllib3
    zict
  ];

  # When tested random tests would fail and not repeatably
  doCheck = false;

  pythonImportsCheck = [ "distributed" ];

  meta = {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    changelog = "https://github.com/dask/distributed/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
