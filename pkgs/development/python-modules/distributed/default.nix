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
  zict,
}:

buildPythonPackage (finalAttrs: {
  pname = "distributed";
  version = "2026.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "distributed";
    tag = finalAttrs.version;
    hash = "sha256-uitjTP79aO2emx5wWM3PlICah0xN1K8m2ad3yN4oSPU=";
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
    zict
  ];

  # When tested random tests would fail and not repeatably
  doCheck = false;

  pythonImportsCheck = [ "distributed" ];

  meta = {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    changelog = "https://github.com/dask/distributed/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
})
