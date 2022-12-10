{ lib
, buildPythonPackage
, fetchFromGitHub
, python
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
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-rWrbHHcJMahaUV8+YuKkZUhdboNFUK9btjvdg74lCxc=";
  };

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
