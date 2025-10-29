{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pbr,
  setuptools,

  # dependencies
  debtcollector,
  iso8601,
  netaddr,
  netifaces,
  oslo-i18n,
  packaging,
  psutil,
  pyparsing,
  pytz,
  tzdata,

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
  replaceVars,
  stdenv,
  stestr,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "oslo-utils";
  version = "9.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_utils";
    inherit version;
    hash = "sha256-AcOHXnzKAFtZRlxCn0ZxE7X0sEIRy9U0yawvFSJ207M=";
  };

  patches = [
    (replaceVars ./ctypes.patch {
      crypt = "${lib.getLib libxcrypt-legacy}/lib/libcrypt${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    debtcollector
    iso8601
    netaddr
    netifaces
    oslo-i18n
    packaging
    psutil
    pyparsing
    pytz
    tzdata
  ];

  nativeCheckInputs = [
    ddt
    eventlet
    fixtures
    libredirect.hook
    oslotest
    pyyaml
    qemu-utils
    stestr
    testscenarios
  ];

  # disabled tests:
  # https://bugs.launchpad.net/oslo.utils/+bug/2054134
  # netaddr default behaviour changed to be stricter
  checkPhase = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)

    stestr run -e <(echo "
      oslo_utils.tests.test_netutils.NetworkUtilsTest.test_is_valid_ip
      oslo_utils.tests.test_netutils.NetworkUtilsTest.test_is_valid_ipv4
      oslo_utils.tests.test_eventletutils.EventletUtilsTest.test_event_set_clear_timeout
    ")
  '';

  pythonImportsCheck = [ "oslo_utils" ];

  meta = {
    description = "Oslo Utility library";
    homepage = "https://github.com/openstack/oslo.utils";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
