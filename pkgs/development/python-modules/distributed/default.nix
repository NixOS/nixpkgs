{
  lib,
  buildPythonPackage,
  click,
  cloudpickle,
  dask,
  fetchFromGitHub,
  jinja2,
  locket,
  msgpack,
  packaging,
  psutil,
  pythonOlder,
  pythonRelaxDepsHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  sortedcontainers,
  tblib,
  toolz,
  tornado,
  urllib3,
  versioneer,
  zict,
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "2024.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "distributed";
    rev = "refs/tags/${version}";
    hash = "sha256-GgW9BtTqjac+olAGg+LOO+lTopuUukVUmQ0ZWsMJOc8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "versioneer[toml]==" "versioneer[toml]>=" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    pythonRelaxDepsHook
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
    changelog = "https://github.com/dask/distributed/blob/${version}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
