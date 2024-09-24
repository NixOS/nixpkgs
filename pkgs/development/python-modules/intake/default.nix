{
  lib,
  stdenv,
  appdirs,
  bokeh,
  buildPythonPackage,
  dask,
  entrypoints,
  fetchFromGitHub,
  fsspec,
  hvplot,
  intake-parquet,
  jinja2,
  msgpack,
  msgpack-numpy,
  pandas,
  panel,
  pyarrow,
  pytestCheckHook,
  python-snappy,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  setuptools-scm,
  tornado,
}:

buildPythonPackage rec {
  pname = "intake";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "intake";
    rev = "refs/tags/${version}";
    hash = "sha256-Fyv85HkoE9OPOoSHR1sgCG0iAFuSiQMT7cyZcQyLvv0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

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
    remote = [ requests ];
  };

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export HOME=$(mktemp -d);
    export PATH="$PATH:$out/bin";
  '';

  disabledTestPaths = [
    # Missing plusins
    "intake/catalog/tests/test_alias.py"
    "intake/catalog/tests/test_gui.py"
    "intake/catalog/tests/test_local.py"
    "intake/catalog/tests/test_reload_integration.py"
    "intake/source/tests/test_csv.py"
    "intake/source/tests/test_derived.py"
    "intake/source/tests/test_npy.py"
    "intake/source/tests/test_text.py"
    "intake/tests/test_config.py"
    "intake/tests/test_top_level.py"
  ];

  disabledTests =
    [
      # Disable tests which touch network
      "http"
      "test_address_flag"
      "test_dir"
      "test_discover"
      "test_filtered_compressed_cache"
      "test_flatten_flag"
      "test_get_dir"
      "test_pagination"
      "test_port_flag"
      "test_read_part_compressed"
      "test_read_partition"
      "test_read_pattern"
      "test_remote_arr"
      "test_remote_cat"
      "test_remote_env"
      # ValueError
      "test_datasource_python_to_dask"
      "test_catalog_passthrough"
      # Timing-based, flaky on darwin and possibly others
      "test_idle_timer"
    ]
    ++ lib.optionals
      (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13")
      [
        # Flaky with older low-res mtime on darwin < 10.13 (#143987)
        "test_second_load_timestamp"
      ];

  pythonImportsCheck = [ "intake" ];

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    changelog = "https://github.com/intake/intake/blob/${version}/docs/source/changelog.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
