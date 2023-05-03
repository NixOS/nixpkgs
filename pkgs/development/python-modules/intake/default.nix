{ lib
, appdirs
, bokeh
, buildPythonPackage
, dask
, entrypoints
, fetchFromGitHub
, fsspec
, hvplot
, intake-parquet
, jinja2
, msgpack
, msgpack-numpy
, numpy
, pandas
, panel
, pyarrow
, pytestCheckHook
, python-snappy
, pythonOlder
, pyyaml
, requests
, stdenv
, tornado
}:

buildPythonPackage rec {
  pname = "intake";
  version = "0.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7A9wuuOQyGhdGj6T5VY+NrZjEOf/y8dCzSkHuPhNsKI=";
  };

  propagatedBuildInputs = [
    appdirs
    dask
    entrypoints
    fsspec
    msgpack
    jinja2
    pandas
    pyyaml
  ];

  nativeCheckInputs = [
    intake-parquet
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  passthru.optional-dependencies = {
    server = [
      msgpack
      python-snappy
      tornado
    ];
    dataframe = [
      msgpack-numpy
      pyarrow
    ];
    plot = [
      hvplot
      bokeh
      panel
    ];
    remote = [
      requests
    ];
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # Disable tests which touch network
    "http"
    "test_dir"
    "test_discover"
    "test_filtered_compressed_cache"
    "test_flatten_flag"
    "test_get_dir"
    "test_pagination"
    "test_read_part_compressed"
    "test_read_partition"
    "test_read_pattern"
    "test_remote_arr"
    "test_remote_cat"
    "test_remote_env"
    # ValueError
    "test_mlist_parameter"
    # ImportError
    "test_dataframe"
    "test_ndarray"
    "test_python"
    # Timing-based, flaky on darwin and possibly others
    "TestServerV1Source.test_idle_timer"
  ] ++ lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13") [
    # Flaky with older low-res mtime on darwin < 10.13 (#143987)
    "test_second_load_timestamp"
  ];

  pythonImportsCheck = [
    "intake"
  ];

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    changelog = "https://github.com/intake/intake/blob/${version}/docs/source/changelog.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
