{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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
  version = "0.35.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eventlet";
    repo = "eventlet";
    rev = "v${version}";
    hash = "sha256-jMbCxqIn9f9+16rFwpQdkBHj6NwTNkQxnSVV4qQ1fjM=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    dnspython
    greenlet
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # libredirect is not available on darwin
  # tests hang on pypy indefinitely
  doCheck = !stdenv.isDarwin && !isPyPy;

  preCheck = lib.optionalString doCheck ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so

    export EVENTLET_IMPORT_VERSION_ONLY=0
  '';

  disabledTests = [
    # AssertionError: Expected single line "pass" in stdout
    "test_fork_after_monkey_patch"
    # Tests requires network access
    "test_getaddrinfo"
    "test_hosts_no_network"
  ];

  pythonImportsCheck = [ "eventlet" ];

  meta = with lib; {
    changelog = "https://github.com/eventlet/eventlet/blob/v${version}/NEWS";
    description = "Concurrent networking library for Python";
    homepage = "https://github.com/eventlet/eventlet/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
