{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  gitMinimal,

  # dependencies
  cramjam,
  fsspec,
  numpy,
  packaging,
  pandas,

  # optional-dependencies
  python-lzo,

  # tests
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2025.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "fastparquet";
    tag = version;
    hash = "sha256-cebu3E2sbVWRUYbSeuslCZhaF+zWV7E56iSwB7Ms3ts=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    gitMinimal
  ];

  dependencies = [
    cramjam
    fsspec
    numpy
    packaging
    pandas
  ];

  optional-dependencies = {
    lzo = [ python-lzo ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # Workaround https://github.com/NixOS/nixpkgs/issues/123561
  preCheck = ''
    mv fastparquet/test .
    rm -r fastparquet
    fastparquet_test="$out"/${python.sitePackages}/fastparquet/test
    ln -s `pwd`/test "$fastparquet_test"
  '';

  postCheck = ''
    rm "$fastparquet_test"
  '';

  pythonImportsCheck = [ "fastparquet" ];

  meta = {
    description = "Implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    changelog = "https://github.com/dask/fastparquet/blob/${version}/docs/source/releasenotes.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
