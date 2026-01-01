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
  version = "3.0.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "datafolklabs";
    repo = "cement";
    tag = version;
    hash = "sha256-hZ9kKQmMomjy5nnHKQ2RWB+6vIID8XMn3qutg0wCBq8=";
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "CLI Application Framework for Python";
    homepage = "https://builtoncement.com/";
    changelog = "https://github.com/datafolklabs/cement/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eqyiel ];
=======
  meta = with lib; {
    description = "CLI Application Framework for Python";
    homepage = "https://builtoncement.com/";
    changelog = "https://github.com/datafolklabs/cement/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eqyiel ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cement";
  };
}
