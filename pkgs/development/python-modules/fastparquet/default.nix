{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, cython
<<<<<<< HEAD
, oldest-supported-numpy
, setuptools
, setuptools-scm
=======
, setuptools
, substituteAll
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, numpy
, pandas
, cramjam
, fsspec
, thrift
, python-lzo
, pytestCheckHook
, pythonOlder
, packaging
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "fastparquet";
<<<<<<< HEAD
  version = "2023.7.0";
=======
  version = "2023.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
<<<<<<< HEAD
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
=======
    hash = "sha256-1hWiwXjTgflQlmy0Dk2phUa1cgYBvvH99tb0TdUmDRI=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
