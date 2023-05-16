<<<<<<< HEAD
{ lib
, brotli
, buildPythonPackage
, cython
, execnet
, fetchFromGitHub
, jinja2
, pytestCheckHook
, pythonOlder
, pyzmq
, redis
, setuptools
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "logbook";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "getlogbook";
    repo = "logbook";
    rev = "refs/tags/${version}";
    hash = "sha256-2K6fM6MFrh3l0smhSz8RFd79AIOXQZJQbNLTJM4WZUo=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  passthru.optional-dependencies = {
    execnet = [
      execnet
    ];
    sqlalchemy = [
      sqlalchemy
    ];
    redis = [
      redis
    ];
    zmq = [
      pyzmq
    ];
    compression = [
      brotli
    ];
    jinja = [
      jinja2
    ];
    all = [
      brotli
      execnet
      jinja2
      pyzmq
      redis
      sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
=======
{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, brotli }:

buildPythonPackage rec {
  pname = "logbook";
  version = "1.5.3";

  src = fetchPypi {
    pname = "Logbook";
    inherit version;
    sha256 = "1s1gyfw621vid7qqvhddq6c3z2895ci4lq3g0r1swvpml2nm9x36";
  };

  nativeCheckInputs = [ pytest ] ++ lib.optionals (!isPy3k) [ mock ];

  propagatedBuildInputs = [ brotli ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

<<<<<<< HEAD
  pythonImportsCheck = [
    "logbook"
  ];

  disabledTests = [
    # Test require Redis instance
    "test_redis_handler"
  ];

  meta = with lib; {
    description = "A logging replacement for Python";
    homepage = "https://logbook.readthedocs.io/";
    changelog = "https://github.com/getlogbook/logbook/blob/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
  meta = {
    homepage = "https://pythonhosted.org/Logbook/";
    description = "A logging replacement for Python";
    license = lib.licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
