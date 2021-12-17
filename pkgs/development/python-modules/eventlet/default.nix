{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, dnspython
, greenlet
, monotonic
, six
, nose
, pyopenssl
, iana-etc
, libredirect
}:

buildPythonPackage rec {
  pname = "eventlet";
  version = "0.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f0bb8ed0dc0ab21d683975d5d8ab3c054d588ce61def9faf7a465ee363e839b";
  };

  propagatedBuildInputs = [ dnspython greenlet pyopenssl six ]
    ++ lib.optional (pythonOlder "3.5") monotonic;

  checkInputs = [ nose ];

  doCheck = !stdenv.isDarwin;

  preCheck = lib.optionalString doCheck ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so

    export EVENTLET_IMPORT_VERSION_ONLY=0
  '';

  checkPhase = ''
    runHook preCheck

    # test_fork-after_monkey_patch fails on aarch64 on hydra only
    #   AssertionError: Expected single line "pass" in stdout
    nosetests --exclude test_getaddrinfo --exclude test_hosts_no_network --exclude test_fork_after_monkey_patch

    runHook postCheck
  '';

  # unfortunately, it needs /etc/protocol to be present to not fail
  # pythonImportsCheck = [ "eventlet" ];

  meta = with lib; {
    homepage = "https://github.com/eventlet/eventlet/";
    description = "A concurrent networking library for Python";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.mit;
  };
}
