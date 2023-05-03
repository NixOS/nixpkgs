{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, cython
, setuptools
, substituteAll
, numpy
, pandas
, cramjam
, fsspec
, thrift
, python-lzo
, pytestCheckHook
, pythonOlder
, packaging
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2023.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-p8JydnrDEl9W4clrOkd+np0NYGP3hVnq+lyyF/zaVk8=";
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
