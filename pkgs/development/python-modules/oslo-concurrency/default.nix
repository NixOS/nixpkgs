{
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
  setuptools,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-concurrency";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.concurrency";
    inherit version;
    hash = "sha256-tWSuCvLuV3DztuYw3yakuGdsf+Qih/GIPiWaUard8Jc=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt

    substituteInPlace oslo_concurrency/tests/unit/test_processutils.py \
      --replace-fail "/bin/bash" "${bash}/bin/bash" \
      --replace-fail "/usr/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/usr/bin/env" "${coreutils}/bin/env"
  '';

  build-system = [ setuptools ];

  dependencies = [
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
    description = "Oslo Concurrency library";
    mainProgram = "lockutils-wrapper";
    homepage = "https://github.com/openstack/oslo.concurrency";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
