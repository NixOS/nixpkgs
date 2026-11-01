{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pbr,
  setuptools,

  # dependencies
  cryptography,
  debtcollector,
  iso8601,
  netaddr,
  oslo-i18n,
  packaging,
  psutil,
  pyparsing,
  pytz,

  # tests
  ddt,
  eventlet,
  fixtures,
  iana-etc,
  libredirect,
  libxcrypt-legacy,
  oslotest,
  pyyaml,
  qemu-utils,
  stdenv,
  stestrCheckHook,
  testscenarios,
  tzdata,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-utils";
  version = "10.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.utils";
    tag = finalAttrs.version;
    hash = "sha256-0Q8gKL7h9IF9K6wH8yF4J+g6KYqS9tAcXLkIJSkmbG8=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch =
    let
      soext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      # pbr needs git to ship subpackages and package data
      echo "recursive-include oslo_utils *" > MANIFEST.in

      substituteInPlace oslo_utils/secretutils.py \
        --replace-fail "ctypes.util.find_library(\"crypt\")" '"${lib.getLib libxcrypt-legacy}/lib/libcrypt${soext}"'

      # only a small portion of the listed packages are actually needed for running the tests
      # so instead of removing them one by one remove everything
      rm test-requirements.txt
    '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cryptography
    debtcollector
    iso8601
    netaddr
    oslo-i18n
    packaging
    psutil
    pyparsing
    pytz
  ];

  nativeCheckInputs = [
    ddt
    eventlet
    fixtures
    libredirect.hook
    oslotest
    pyyaml
    qemu-utils
    stestrCheckHook
    testscenarios
    tzdata
  ];

  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
  '';

  disabledTests = [
    # https://bugs.launchpad.net/oslo.utils/+bug/2054134
    # netaddr default behaviour changed to be stricter
    "oslo_utils.tests.test_netutils.NetworkUtilsTest.test_is_valid_ip"
    "oslo_utils.tests.test_netutils.NetworkUtilsTest.test_is_valid_ipv4"
    "oslo_utils.tests.test_eventletutils.EventletUtilsTest.test_event_set_clear_timeout"
  ];

  pythonImportsCheck = [
    "oslo_utils"
    "oslo_utils.imageutils"
  ];

  meta = {
    description = "Oslo Utility library";
    homepage = "https://github.com/openstack/oslo.utils";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
