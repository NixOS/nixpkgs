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
  pythonOlder,
  pyyaml,
  redis,
  requests,
  tabulate,
  watchdog,
}:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "datafolklabs";
    repo = "cement";
    rev = "refs/tags/${version}";
    hash = "sha256-weBqmNEjeSh5YQfHK48VVFW3UbZQmV4MiIQ3UPQKTTI=";
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "cement" ];

  # Tests are failing on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Test only works with the source from PyPI
    "test_get_version"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/ext/test_ext_memcached.py"
    "tests/ext/test_ext_redis.py"
    "tests/ext/test_ext_smtp.py"
  ];

  meta = with lib; {
    description = "CLI Application Framework for Python";
    homepage = "https://builtoncement.com/";
    changelog = "https://github.com/datafolklabs/cement/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eqyiel ];
    mainProgram = "cement";
  };
}
