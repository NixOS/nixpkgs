{ lib
, buildPythonPackage
, fetchPypi
, click
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-configfile";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "lb7sE77pUOmPQ8gdzavvT2RAkVWepmKY+drfWTUdkNE=";
  };

  propagatedBuildInputs = [
    click
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_configfile__with_unbound_section"
    "test_matches_section__with_bad_arg"
  ];

  meta = with lib; {
    description = "Add support for commands that use configuration files to Click";
    homepage = "https://github.com/click-contrib/click-configfile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
