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
  version = "2024.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "distributed";
    rev = "refs/tags/${version}";
    hash = "sha256-9W5BpBQHw1ZXCOWiFPeIlMns/Yys1gtdwQ4Lhd7qjK8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "versioneer[toml]==" "versioneer[toml]>=" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
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

  meta = with lib; {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    changelog = "https://github.com/dask/distributed/blob/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
