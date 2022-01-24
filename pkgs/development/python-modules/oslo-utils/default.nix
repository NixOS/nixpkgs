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
, stestr
, testscenarios
, pyyaml
, iana-etc
, libredirect
}:

buildPythonPackage rec {
  pname = "oslo-utils";
  version = "4.12.1";

  src = fetchPypi {
    pname = "oslo.utils";
    inherit version;
    sha256 = "sha256-zzEhx2/jwpY+1WOo68PJ/TvDy6XUT76K7LVAfUMMMJI=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    debtcollector
    iso8601
    netaddr
    netifaces
    oslo-i18n
    packaging
    pyparsing
    pytz
  ];

  checkInputs = [
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
