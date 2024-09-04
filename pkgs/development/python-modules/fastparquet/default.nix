{
  lib,
  buildPythonPackage,
  cramjam,
  cython,
  fetchFromGitHub,
  fsspec,
  git,
  numpy,
  oldest-supported-numpy,
  packaging,
  pandas,
  pytestCheckHook,
  python-lzo,
  python,
  pythonOlder,
  setuptools-scm,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2024.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "fastparquet";
    rev = "refs/tags/${version}";
    hash = "sha256-YiaVkpPzH8ZmTiEtCom9xLbKzByIt7Ilig/WlmGrYH4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0rc1" "oldest-supported-numpy"
  '';

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeBuildInputs = [
    cython
    git
    oldest-supported-numpy
  ];

  dependencies = [
    cramjam
    fsspec
    numpy
    packaging
    pandas
  ];

  passthru.optional-dependencies = {
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

  meta = with lib; {
    description = "Implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    changelog = "https://github.com/dask/fastparquet/blob/${version}/docs/source/releasenotes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
  };
}
