{ stdenv
, lib
<<<<<<< HEAD
, backports-zoneinfo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, billiard
, boto3
, buildPythonPackage
, case
, click
, click-didyoumean
, click-plugins
, click-repl
, dnspython
, fetchPypi
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, kombu
, moto
, pymongo
, pytest-celery
<<<<<<< HEAD
, pytest-click
, pytest-subtests
, pytest-timeout
, pytestCheckHook
, python-dateutil
, pythonOlder
, tzdata
=======
, pytest-subtests
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pytz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, vine
, nixosTests
}:

buildPythonPackage rec {
  pname = "celery";
<<<<<<< HEAD
  version = "5.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kCPfaoli2nnrMMDITV9IY9l5OkZjVMyTHX9yQjmW3ig=";
  };

=======
  version = "5.2.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+vvYKTTTD4oAT4Ho96Bi4xQToj1ES+juMyZVORWVjG0=";
  };

  patches = [
    (fetchpatch {
      name = "billiard-4.0-compat.patch";
      url = "https://github.com/celery/celery/commit/b260860988469ef8ad74f2d4225839c2fa91d590.patch";
      hash = "sha256-NWB/UB0fE7A/vgMRYz6QGmqLmyN1ninAMyL4V2tpzto=";
    })
    (fetchpatch  {
      name = "billiard-4.1-compat.patch";
      url = "https://github.com/celery/celery/pull/7781/commits/879af6341974c3778077d8212d78f093b2d77a4f.patch";
      hash = "sha256-+m8/YkeAPPjwm0WF7dw5XZzf7MImVBLXT0/FS+fk0FE=";
    })
  ];

  postPatch = ''
    substituteInPlace requirements/default.txt \
      --replace "billiard>=3.6.4.0,<4.0" "billiard>=3.6.4.0"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    billiard
    click
    click-didyoumean
    click-plugins
    click-repl
    kombu
<<<<<<< HEAD
    python-dateutil
    tzdata
    vine
  ]
  ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
=======
    pytz
    vine
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    boto3
    case
    dnspython
    moto
    pymongo
    pytest-celery
<<<<<<< HEAD
    pytest-click
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-subtests
    pytest-timeout
    pytestCheckHook
  ];

  disabledTestPaths = [
    # test_eventlet touches network
    "t/unit/concurrency/test_eventlet.py"
    # test_multi tries to create directories under /var
    "t/unit/bin/test_multi.py"
    "t/unit/apps/test_multi.py"
  ];

  disabledTests = [
    "msgpack"
    "test_check_privileges_no_fchown"
  ] ++ lib.optionals stdenv.isDarwin [
    # too many open files on hydra
    "test_cleanup"
    "test_with_autoscaler_file_descriptor_safety"
    "test_with_file_descriptor_safety"
  ];

  pythonImportsCheck = [
    "celery"
  ];

  passthru.tests = {
    inherit (nixosTests) sourcehut;
  };

  meta = with lib; {
    description = "Distributed task queue";
    homepage = "https://github.com/celery/celery/";
<<<<<<< HEAD
    changelog = "https://github.com/celery/celery/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
