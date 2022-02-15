{ lib
, buildPythonPackage
, fetchPypi
, click
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "click-configfile";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lb7sE77pUOmPQ8gdzavvT2RAkVWepmKY+drfWTUdkNE=";
  };

  propagatedBuildInputs = [
    click
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "install_requires=install_requires," 'install_requires=["click >= 6.6", "six >= 1.10"],'
  '';

  pythonImportsCheck = [
    "click_configfile"
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
