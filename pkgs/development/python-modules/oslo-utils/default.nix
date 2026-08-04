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

buildPythonPackage rec {
  pname = "oslo-utils";
  version = "10.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_utils";
    inherit version;
    hash = "sha256-Ib/Cm7TBzZr7TvdB+445Ro+lSF5gcX9PkPOtPc6KHyI=";
  };

  postPatch =
    let
      soext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
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

  pythonImportsCheck = [ "oslo_utils" ];

  meta = {
    description = "Oslo Utility library";
    homepage = "https://github.com/openstack/oslo.utils";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
