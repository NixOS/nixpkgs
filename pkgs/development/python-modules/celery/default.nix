{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  billiard,
  kombu,
  vine,
  click,
  click-didyoumean,
  click-repl,
  click-plugins,
  tzdata,
  python-dateutil,

  # optional-dependencies
  google-cloud-storage,
  moto,
  msgpack,
  pymongo,
  pyyaml,

  # tests
  pytest-celery,
  pytest-click,
  pytest-subtests,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UEoZFA6NMCnVrK2IMwxUHUw/ZMeJ2F+UdWdi2Lyn5wY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    billiard
    click
    click-didyoumean
    click-plugins
    click-repl
    kombu
    python-dateutil
    tzdata
    vine
  ];

  optional-dependencies = {
    gcs = [ google-cloud-storage ];
    mongodb = [ pymongo ];
    msgpack = [ msgpack ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs =
    [
      moto
      pytest-celery
      pytest-click
      pytest-subtests
      pytest-timeout
      pytest-xdist
      pytestCheckHook
    ]
    # based on https://github.com/celery/celery/blob/main/requirements/test.txt
    ++ optional-dependencies.yaml
    ++ optional-dependencies.msgpack
    ++ optional-dependencies.mongodb
    ++ optional-dependencies.gcs;

  disabledTestPaths = [
    # test_eventlet touches network
    "t/unit/concurrency/test_eventlet.py"
    # test_multi tries to create directories under /var
    "t/unit/bin/test_multi.py"
    "t/unit/apps/test_multi.py"
    # requires moto<5
    "t/unit/backends/test_s3.py"
  ];

  disabledTests =
    [
      "msgpack"
      "test_check_privileges_no_fchown"
      # seems to only fail on higher core counts
      # AssertionError: assert 3 == 0
      "test_setup_security_disabled_serializers"
      # fails with pytest-xdist
      "test_itercapture_limit"
      "test_stamping_headers_in_options"
      "test_stamping_with_replace"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # too many open files on hydra
      "test_cleanup"
      "test_with_autoscaler_file_descriptor_safety"
      "test_with_file_descriptor_safety"
    ];

  pythonImportsCheck = [ "celery" ];

  passthru.tests = {
    inherit (nixosTests) sourcehut;
  };

  meta = with lib; {
    description = "Distributed task queue";
    mainProgram = "celery";
    homepage = "https://github.com/celery/celery/";
    changelog = "https://github.com/celery/celery/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
