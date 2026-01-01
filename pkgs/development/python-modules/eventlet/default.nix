{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  dnspython,
  greenlet,
  isPyPy,
  six,

  # tests
  iana-etc,
  pytestCheckHook,
  libredirect,
}:

buildPythonPackage rec {
  pname = "eventlet";
<<<<<<< HEAD
  version = "0.40.3";
=======
  version = "0.40.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eventlet";
    repo = "eventlet";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-yieyNx91jvKoh02zDFIEFk70yf3I27DWiumqoOjtdzQ=";
=======
    hash = "sha256-fzCN+idYQ97nuDVfYn6VYQFBaaMxmnjWzFrmn+Aj+u4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = lib.optionals isPyPy [ "greenlet" ];

<<<<<<< HEAD
  build-system = [
=======
  nativeBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hatch-vcs
    hatchling
  ];

<<<<<<< HEAD
  dependencies = [
=======
  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    dnspython
    greenlet
    six
  ];

  nativeCheckInputs = [
    libredirect.hook
    pytestCheckHook
  ];

  # tests hang on pypy indefinitely
  # most tests also fail/flake on Darwin
  doCheck = !isPyPy && !stdenv.hostPlatform.isDarwin;

  preCheck = lib.optionalString doCheck ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)

    export EVENTLET_IMPORT_VERSION_ONLY=0
  '';

  disabledTests = [
    # AssertionError: Expected single line "pass" in stdout
    "test_fork_after_monkey_patch"
    # Tests requires network access
    "test_getaddrinfo"
    "test_hosts_no_network"
    # flaky test, depends on builder performance
    "test_server_connection_timeout_exception"
    # broken with openssl 3.4
    "test_ssl_close"
    # flaky test
    "test_send_timeout"
  ];

  pythonImportsCheck = [ "eventlet" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/eventlet/eventlet/blob/${src.tag}/NEWS";
    description = "Concurrent networking library for Python";
    homepage = "https://github.com/eventlet/eventlet/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
=======
  meta = with lib; {
    changelog = "https://github.com/eventlet/eventlet/blob/v${version}/NEWS";
    description = "Concurrent networking library for Python";
    homepage = "https://github.com/eventlet/eventlet/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
