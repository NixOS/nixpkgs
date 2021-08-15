{ stdenv, lib, buildPythonPackage, fetchPypi
, pbr, oslo-config, oslo-context, oslo-i18n, oslo-utils, oslo-serialization, debtcollector, pyinotify, python-dateutil
, stestr, oslotest }:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "4.6.0";

  src = fetchPypi {
    inherit version;
    pname = "oslo.log";
    sha256 = "19sv70dx77l47vkwq1ahkn9a764znwdnmlsnncr13w4h2bzxgmfs";
  };

  postPatch = lib.optionalString (!stdenv.isLinux) ''
    # Test depends on pyinotify
    substituteInPlace oslo_log/tests/unit/test_log.py --replace test_watchlog_on_linux __test_watchlog_on_linux
  '';

  propagatedBuildInputs = [
    pbr
    oslo-config
    oslo-context
    oslo-i18n
    oslo-utils
    oslo-serialization
    debtcollector
    python-dateutil
  ] ++ lib.optionals stdenv.isLinux [
    pyinotify
  ];

  checkInputs = [ stestr oslotest ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "oslo_log" ];

  meta = with lib; {
    description = "Oslo Logging Library";
    homepage = "https://docs.openstack.org/oslo.log/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
