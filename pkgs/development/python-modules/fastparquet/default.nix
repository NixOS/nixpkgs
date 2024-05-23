{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  cython,
  oldest-supported-numpy,
  setuptools,
  setuptools-scm,
  numpy,
  pandas,
  cramjam,
  fsspec,
  thrift,
  python-lzo,
  pytestCheckHook,
  pythonOlder,
  packaging,
  wheel,
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2024.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "fastparquet";
    rev = "refs/tags/${version}";
    hash = "sha256-e0gnC/HMYdrYdEwy6qNOD1J52xgN2x81oCG03YNsYjg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pytest-runner"' ""

    sed -i \
      -e "/pytest-runner/d" \
      -e '/"git", "status"/d' setup.py
  '';

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    cramjam
    fsspec
    numpy
    pandas
    thrift
    packaging
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
