{
  lib,
  stdenv,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  jinja2,
  mock,
  pdm-backend,
  pylibmc,
  pystache,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  redis,
  requests,
  tabulate,
  watchdog,
}:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datafolklabs";
    repo = "cement";
    tag = version;
    hash = "sha256-oSVZrplmcZbN5engQ54f5siLNWoR13qcKuhxNA62jDU=";
  };

  build-system = [ pdm-backend ];

  optional-dependencies = {
    colorlog = [ colorlog ];
    jinja2 = [ jinja2 ];
    mustache = [ pystache ];
    generate = [ pyyaml ];
    redis = [ redis ];
    memcached = [ pylibmc ];
    tabulate = [ tabulate ];
    watchdog = [ watchdog ];
    yaml = [ pyyaml ];
    cli = [
      jinja2
      pyyaml
    ];
  };

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytestCheckHook
    requests
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "cement" ];

  # Tests are failing on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Test only works with the source from PyPI
    "test_get_version"
    "test_generate_todo_ruff_clean"
    "test_clear_loggers"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/ext/test_ext_memcached.py"
    "tests/ext/test_ext_redis.py"
    "tests/ext/test_ext_smtp.py"
  ];

  meta = {
    description = "CLI Application Framework for Python";
    homepage = "https://builtoncement.com/";
    changelog = "https://github.com/datafolklabs/cement/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eqyiel ];
    mainProgram = "cement";
  };
}
