{ lib
, buildPythonPackage
, click
, cloudpickle
, dask
, fetchFromGitHub
, jinja2
, locket
, msgpack
, packaging
, psutil
, pythonOlder
, pyyaml
, setuptools
, setuptools-scm
, sortedcontainers
, tblib
, toolz
, tornado
, urllib3
, versioneer
, zict
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "2023.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "distributed";
    rev = "refs/tags/${version}";
    hash = "sha256-V0L1qY9xtJgKxNEZ69z8CQuXsUs30cqu6xFrsjKWkbY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "versioneer[toml]==" "versioneer[toml]>=" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    versioneer
  ] ++ versioneer.optional-dependencies.toml;

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "distributed"
  ];

  meta = with lib; {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    changelog = "https://github.com/dask/distributed/blob/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
