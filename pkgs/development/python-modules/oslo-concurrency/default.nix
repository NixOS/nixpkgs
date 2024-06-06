{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  bash,
  coreutils,
  eventlet,
  fasteners,
  fixtures,
  iana-etc,
  libredirect,
  oslo-config,
  oslo-utils,
  oslotest,
  pbr,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-concurrency";
  version = "6.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "oslo.concurrency";
    inherit version;
    hash = "sha256-tS8CtORvXydLkfuOG/xcv5pBjfzUqDvggDRUlePSboo=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt

    substituteInPlace oslo_concurrency/tests/unit/test_processutils.py \
      --replace "/bin/bash" "${bash}/bin/bash" \
      --replace "/bin/true" "${coreutils}/bin/true" \
      --replace "/usr/bin/env" "${coreutils}/bin/env" \
      --replace "/usr/bin/true" "${coreutils}/bin/true"
  '';

  propagatedBuildInputs = [
    fasteners
    oslo-config
    oslo-utils
    pbr
  ];

  # tests hang for unknown reason and time the build out
  doCheck = false;

  nativeCheckInputs = [
    eventlet
    fixtures
    oslotest
    stestr
  ];

  checkPhase = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so

    stestr run -e <(echo "
    oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_fair_lock_with_spawn
    oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_fair_lock_with_spawn_n
    ")
  '';

  pythonImportsCheck = [ "oslo_concurrency" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Oslo Concurrency library";
    mainProgram = "lockutils-wrapper";
    homepage = "https://github.com/openstack/oslo.concurrency";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
