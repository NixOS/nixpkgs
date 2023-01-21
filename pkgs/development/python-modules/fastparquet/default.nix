{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, cython
, setuptools
, substituteAll
, numba
, numpy
, pandas
, cramjam
, fsspec
, thrift
, python-lzo
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2022.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-/DSe2vZwrHHTuAXWJh9M1wCes5c4/QAVUnJVEI4Evyw=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  patches = [
    (substituteAll {
      src = ./version.patch;
      inherit version;
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "oldest-supported-numpy" "numpy"

    sed -i '/"git", "status"/d' setup.py
  '';

  propagatedBuildInputs = [
    cramjam
    fsspec
    numba
    numpy
    pandas
    thrift
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
