{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, cython
, oldest-supported-numpy
, setuptools
, setuptools-scm
, numpy
, pandas
, cramjam
, fsspec
, thrift
, python-lzo
, pytestCheckHook
, pythonOlder
, packaging
, wheel
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2023.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-pJ0zK0upEV7TyuNMIcozugkwBlYpK/Dg6BdB0kBpn9k=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    setuptools-scm
    wheel
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"pytest-runner"' ""

    sed -i \
      -e "/pytest-runner/d" \
      -e '/"git", "status"/d' setup.py
  '';

  propagatedBuildInputs = [
    cramjam
    fsspec
    numpy
    pandas
    thrift
    packaging
  ];

  passthru.optional-dependencies = {
    lzo = [
      python-lzo
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

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

  pythonImportsCheck = [
    "fastparquet"
  ];

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
