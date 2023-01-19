{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, cython
, numba
, numpy
, pandas
, cramjam
, fsspec
, git
, thrift
, setuptools-scm
, python-lzo
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2022.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-/DSe2vZwrHHTuAXWJh9M1wCes5c4/QAVUnJVEI4Evyw=";
  };

  propagatedBuildInputs = [
    cramjam
    fsspec
    numba
    numpy
    pandas
    thrift
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION="${version}";

  nativeBuildInputs = [
    git
    cython
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    lzo = [
      python-lzo
    ];
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "oldest-supported-numpy" "numpy"
  '';


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
