{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
, debtcollector
, importlib-metadata
, netaddr
, oslo-i18n
, pbr
, pyyaml
, requests
, rfc3986
, stevedore

, doc8
, fixtures
, tox
}:

buildPythonPackage rec {
  pname = "oslo-config";
  version = "8.3.1";

  upper-constraints = fetchurl {
    url = "https://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt";
    sha256 = "0l46zy9vrkgycyfc0s9lqscvcaad07bl2lzw3gnq99i61brx4wg0";
  };

  src = fetchPypi {
    pname = "oslo.config";
    inherit version;
    sha256 = "1z47kszi1m9gvw4m7xnfy9knln0p5wjnffbgp7wdv1jcbgf87fyz";
  };

  patches = [ ./tox-pass-system-pythonpath.patch ];

  propagatedBuildInputs = [
    debtcollector
    importlib-metadata
    netaddr
    oslo-i18n
    pbr
    pyyaml
    requests
    rfc3986
    stevedore
  ];
  checkInputs = [
    doc8
    fixtures
    oslo-i18n
    tox
  ];

  checkPhase = ''
    export UPPER_CONSTRAINTS_FILE="${upper-constraints}"
    tox; cat /build/oslo.config-8.3.1/.tox/py37/log/py37-1.log; return 1
  '';

  # Circular dependencies on oslotest, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  doCheck = false;

  meta = with lib; {
    description = "Oslo Configuration API";
    license = licenses.asl20;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
