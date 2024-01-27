{ lib
, buildPythonPackage
, fetchPypi
, ddt
, debtcollector
, eventlet
, fixtures
, iso8601
, netaddr
, netifaces
, oslo-i18n
, oslotest
, packaging
, pbr
, pyparsing
, pytz
, setuptools
, stestr
, testscenarios
, tzdata
, pyyaml
, iana-etc
, libredirect
}:

buildPythonPackage rec {
  pname = "oslo-utils";
  version = "6.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.utils";
    inherit version;
    hash = "sha256-dY2UWyutW+qBq+2ArTP/6h0deTNIrF61s4Zrp0WxHVU=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    debtcollector
    iso8601
    netaddr
    netifaces
    oslo-i18n
    packaging
    pyparsing
    pytz
    tzdata
  ];

  nativeCheckInputs = [
    ddt
    eventlet
    fixtures
    oslotest
    stestr
    testscenarios
    pyyaml
  ];

  checkPhase = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so

    stestr run
  '';

  pythonImportsCheck = [ "oslo_utils" ];

  meta = with lib; {
    description = "Oslo Utility library";
    homepage = "https://github.com/openstack/oslo.utils";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
