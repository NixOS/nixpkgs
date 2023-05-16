{ lib
, stdenv
<<<<<<< HEAD
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, wheel

# dependencies
, click
, cloudpickle
, fsspec
, importlib-metadata
, packaging
, partd
, pyyaml
, toolz

# optional-dependencies
, numpy
, pyarrow
, lz4
, pandas
, distributed
, bokeh
, jinja2

# tests
, arrow-cpp
, hypothesis
, pytest-asyncio
=======
, arrow-cpp
, bokeh
, buildPythonPackage
, click
, cloudpickle
, distributed
, fastparquet
, fetchFromGitHub
, fetchpatch
, fsspec
, importlib-metadata
, jinja2
, numpy
, packaging
, pandas
, partd
, pyarrow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
=======
, pyyaml
, scipy
, setuptools
, toolz
, versioneer
, zarr
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "dask";
<<<<<<< HEAD
  version = "2023.8.0";
  format = "pyproject";
=======
  version = "2023.4.1";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask";
<<<<<<< HEAD
    repo = "dask";
    rev = "refs/tags/${version}";
    hash = "sha256-ZKjfxTJCu3EUOKz16+VP8+cPqQliFNc7AU1FPC1gOXw=";
=======
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PkEFXF6OFZU+EMFBUopv84WniQghr5Q6757Qx6D5MyE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
    versioneer
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    click
    cloudpickle
    fsspec
    packaging
    partd
    pyyaml
    importlib-metadata
    toolz
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = lib.fix (self: {
=======
  passthru.optional-dependencies = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    array = [
      numpy
    ];
    complete = [
<<<<<<< HEAD
      pyarrow
      lz4
    ]
    ++ self.array
    ++ self.dataframe
    ++ self.distributed
    ++ self.diagnostics;
=======
      distributed
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dataframe = [
      numpy
      pandas
    ];
    distributed = [
      distributed
    ];
    diagnostics = [
      bokeh
      jinja2
    ];
<<<<<<< HEAD
  });
=======
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
<<<<<<< HEAD
    # from panda[test]
    hypothesis
    pytest-asyncio
  ] ++ lib.optionals (!arrow-cpp.meta.broken) [ # support is sparse on aarch64
=======
    scipy
    zarr
  ] ++ lib.optionals (!arrow-cpp.meta.broken) [ # support is sparse on aarch64
    fastparquet
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pyarrow
  ];

  dontUseSetuptoolsCheck = true;

  postPatch = ''
    # versioneer hack to set version of GitHub package
    echo "def get_versions(): return {'dirty': False, 'error': None, 'full-revisionid': None, 'version': '${version}'}" > dask/_version.py

    substituteInPlace setup.py \
<<<<<<< HEAD
      --replace "import versioneer" "" \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace "version=versioneer.get_version()," "version='${version}'," \
      --replace "cmdclass=versioneer.get_cmdclass()," ""

    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace ', "versioneer[toml]==0.28"' "" \
      --replace " --durations=10" "" \
      --replace " --cov-config=pyproject.toml" "" \
      --replace "\"-v" "\" "
=======
      --replace " --durations=10" "" \
      --replace " --cov-config=pyproject.toml" "" \
      --replace " -v" ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  pytestFlagsArray = [
    # Rerun failed tests up to three times
    "--reruns 3"
    # Don't run tests that require network access
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Test requires features of python3Packages.psutil that are
    # blocked in sandboxed-builds
    "test_auto_blocksize_csv"
    # AttributeError: 'str' object has no attribute 'decode'
    "test_read_dir_nometa"
  ] ++ [
<<<<<<< HEAD
    # https://github.com/dask/dask/issues/10347#issuecomment-1589683941
    "test_concat_categorical"
    # AttributeError: 'ArrowStringArray' object has no attribute 'tobytes'. Did you mean: 'nbytes'?
    "test_dot"
    "test_dot_nan"
    "test_merge_column_with_nulls"
=======
    "test_chunksize_files"
    # TypeError: 'ArrowStringArray' with dtype string does not support reduction 'min'
    "test_set_index_string"
    # numpy 1.24
    # RuntimeWarning: invalid value encountered in cast
    "test_setitem_extended_API_2d_mask"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "dask"
    "dask.array"
    "dask.bag"
    "dask.bytes"
    "dask.dataframe"
    "dask.dataframe.io"
    "dask.dataframe.tseries"
    "dask.diagnostics"
  ];

  meta = with lib; {
    description = "Minimal task scheduling abstraction";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
