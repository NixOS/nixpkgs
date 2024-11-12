{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  versioneer,

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
  version = "2024.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "distributed";
    rev = "refs/tags/${version}";
    hash = "sha256-pdVqPzz66CueGuha66RTykrLtEGx9i6aScR+NHIYWg0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "versioneer[toml]==" "versioneer[toml]>=" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
    setuptools-scm
    versioneer
  ] ++ versioneer.optional-dependencies.toml;

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
    changelog = "https://github.com/dask/distributed/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
