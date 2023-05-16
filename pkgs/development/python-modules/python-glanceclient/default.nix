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
<<<<<<< HEAD
  version = "4.4.0";
=======
  version = "4.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ejZuH/Zr23bmJ+7PfNQFO9lPNfo83GkNKa/0fpduBTI=";
=======
    hash = "sha256-5nwCPOc9GBxk9BItiaScfy1eljl+e0okFCEOVsHoXDQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
