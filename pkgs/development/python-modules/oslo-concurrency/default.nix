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
  pythonAtLeast,
  setuptools,
  stdenv,
  stestr,
  writeText,
}:

buildPythonPackage rec {
  pname = "oslo-concurrency";
  version = "7.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.concurrency";
    tag = version;
    hash = "sha256-vZWEeyYkdUl9EL4bw6AIbZgVpKXgakvRyFkQAT5GqJ4=";
  };

  postPatch = ''
    substituteInPlace oslo_concurrency/tests/unit/test_processutils.py \
      --replace-fail "/usr" "" \
      --replace-fail "/bin/bash" "${bash}/bin/bash" \
      --replace-fail "/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/bin/env" "${coreutils}/bin/env"

    substituteInPlace pyproject.toml \
      --replace-fail '"oslo_concurrency"' '"oslo_concurrency", "oslo_concurrency.fixture", "oslo_concurrency.tests"'
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

  checkPhase =
    let
      disabledTests = [
        "oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_fair_lock_with_spawn"
        "oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_fair_lock_with_spawn_n"
        "oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_lock_with_spawn"
        "oslo_concurrency.tests.unit.test_lockutils_eventlet.TestInternalLock.test_lock_with_spawn_n"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "oslo_concurrency.tests.unit.test_lockutils.FileBasedLockingTestCase.test_interprocess_nonblocking_external_lock"
        "oslo_concurrency.tests.unit.test_lockutils.LockTestCase.test_lock_externally"
        "oslo_concurrency.tests.unit.test_lockutils.LockTestCase.test_lock_externally_lock_dir_not_exist"
        "oslo_concurrency.tests.unit.test_processutils.PrlimitTestCase.test_stack_size"
      ]
      ++ lib.optionals (pythonAtLeast "3.14") [
        # Disable test incompatible with Python 3.14+
        # See proposed change upstream: https://review.opendev.org/c/openstack/oslo.concurrency/+/971765
        "oslo_concurrency.tests.unit.test_lockutils"
      ];
    in
    ''
      runHook preCheck

      echo "nameserver 127.0.0.1" > resolv.conf
      export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)

      stestr run -e <(echo "${lib.concatStringsSep "\n" disabledTests}")

      runHook postCheck
    '';

  pythonImportsCheck = [ "oslo_concurrency" ];

  meta = {
    description = "Oslo Concurrency library";
    mainProgram = "lockutils-wrapper";
    homepage = "https://github.com/openstack/oslo.concurrency";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
