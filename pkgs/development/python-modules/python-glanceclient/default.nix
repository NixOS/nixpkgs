{ lib
, buildPythonPackage
, fetchPypi
, coreutils
, pbr
, prettytable
, keystoneauth1
, requests
, warlock
, oslo-utils
, oslo-i18n
, wrapt
, pyopenssl
, pythonOlder
, stestr
, testscenarios
, ddt
, requests-mock
}:

buildPythonPackage rec {
  pname = "python-glanceclient";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ejZuH/Zr23bmJ+7PfNQFO9lPNfo83GkNKa/0fpduBTI=";
  };

  postPatch = ''
    substituteInPlace glanceclient/tests/unit/v1/test_shell.py \
      --replace "/bin/echo" "${coreutils}/bin/echo"
  '';

  propagatedBuildInputs = [
    pbr
    prettytable
    keystoneauth1
    requests
    warlock
    oslo-utils
    oslo-i18n
    wrapt
    pyopenssl
  ];

  nativeCheckInputs = [
    stestr
    testscenarios
    ddt
    requests-mock
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [
    "glanceclient"
  ];

  meta = with lib; {
    description = "Python bindings for the OpenStack Images API";
    homepage = "https://github.com/openstack/python-glanceclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
