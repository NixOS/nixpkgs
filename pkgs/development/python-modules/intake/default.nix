{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  dask,
  entrypoints,
  fsspec,
  jinja2,
  msgpack,
  networkx,
  pandas,
  platformdirs,
  pyyaml,

  # optional-dependencies
  # server:
  msgpack-numpy,
  python-snappy,
  tornado,
  # dataframe:
  pyarrow,
  # plot
  hvplot,
  bokeh,
  panel,
  # remote:
  requests,

  # tests
  addBinToPathHook,
  intake-parquet,
  pytestCheckHook,
  pythonAtLeast,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "intake";
  version = "2.0.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "intake";
    repo = "intake";
    tag = finalAttrs.version;
    hash = "sha256-DiALGrJP4vLWygzZprjYCFM+TYtMS7NVM3+MTyjzcs0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dask
    entrypoints
    fsspec
    jinja2
    msgpack
    networkx
    pandas
    platformdirs
    pyyaml
  ];

  optional-dependencies = {
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

  nativeCheckInputs = [
    addBinToPathHook
    intake-parquet
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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

  disabledTests = [
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
  ++ lib.optionals (pythonAtLeast "3.12") [
    # Require deprecated distutils
    "test_which"
    "test_load"
  ];

  pythonImportsCheck = [ "intake" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    changelog = "https://github.com/intake/intake/blob/${finalAttrs.src.rev}/docs/source/changelog.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
