{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bash,
  coreutils,
  debtcollector,
  eventlet,
  fasteners,
  fixtures,
  iana-etc,
  libredirect,
  oslo-config,
  oslo-i18n,
  oslo-utils,
  oslotest,
  pbr,
  setuptools,
  stdenv,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-concurrency";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.concurrency";
    tag = version;
    hash = "sha256-72KatSWTCx4hyUel2Fu5yiqrdYveRGruvJDWWo1hkIk=";
  };

  postPatch = ''
    substituteInPlace oslo_concurrency/tests/unit/test_processutils.py \
      --replace-fail "/usr" "" \
      --replace-fail "/bin/bash" "${bash}/bin/bash" \
      --replace-fail "/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/bin/env" "${coreutils}/bin/env"
  '';

  env.PBR_VERSION = version;

  build-system = [ setuptools ];

  dependencies = [
    debtcollector
    fasteners
    oslo-config
    oslo-i18n
    oslo-utils
    pbr
  ];

  nativeCheckInputs = [
    eventlet
    fixtures
    libredirect.hook
    oslotest
    stestr
  ];

  checkPhase = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)

    stestr run -e <(echo "
    oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_fair_lock_with_spawn
    oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_fair_lock_with_spawn_n
    oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_lock_with_spawn
    oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_lock_with_spawn_n
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      oslo_concurrency.tests.unit.test_lockutils.FileBasedLockingTestCase.test_interprocess_nonblocking_external_lock
      oslo_concurrency.tests.unit.test_lockutils.LockTestCase.test_lock_externally
      oslo_concurrency.tests.unit.test_lockutils.LockTestCase.test_lock_externally_lock_dir_not_exist
      oslo_concurrency.tests.unit.test_processutils.PrlimitTestCase.test_stack_size
    ''}")
  '';

  pythonImportsCheck = [ "oslo_concurrency" ];

  meta = with lib; {
    description = "Oslo Concurrency library";
    mainProgram = "lockutils-wrapper";
    homepage = "https://github.com/openstack/oslo.concurrency";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
