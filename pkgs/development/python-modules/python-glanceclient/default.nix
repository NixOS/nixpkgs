{ lib
, buildPythonApplication
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
, stestr
, testscenarios
, ddt
, requests-mock
}:

buildPythonApplication rec {
  pname = "python-glanceclient";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gi1IYtWJL2pltoKTRy5gsHTRwHlp0GHoBMbh1UP5g9o=";
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

  checkInputs = [
    stestr
    testscenarios
    ddt
    requests-mock
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "glanceclient" ];

  meta = with lib; {
    description = "Python bindings for the OpenStack Images API";
    homepage = "https://github.com/openstack/python-glanceclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
