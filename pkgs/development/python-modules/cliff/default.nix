{ lib
, buildPythonPackage
, fetchPypi
, pbr
, prettytable
, pyparsing
, six
, stevedore
, pyyaml
, cmd2
, pytestCheckHook
, testtools
, fixtures
, which
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "3.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dd215d0a84c9a3ab2fa2aa700849f4e7b786639f66caa0ad4108c85dca95a7c";
  };

  propagatedBuildInputs = [
    pbr
    prettytable
    pyparsing
    six
    stevedore
    pyyaml
    cmd2
  ];

  postPatch = ''
    sed -i -e '/cmd2/c\cmd2' -e '/PrettyTable/c\PrettyTable' requirements.txt
  '';

  checkInputs = [ fixtures pytestCheckHook testtools which ];
  # add some tests
  pytestFlagsArray = [
    "cliff/tests/test_utils.py"
    "cliff/tests/test_app.py"
    "cliff/tests/test_command.py"
    "cliff/tests/test_help.py"
    "cliff/tests/test_lister.py"
  ];

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://docs.openstack.org/cliff/latest/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
