{ lib
, buildPythonPackage
<<<<<<< HEAD
, et_xmlfile
, fetchFromGitLab
, jdcal
, lxml
, pillow
, pytestCheckHook
, pythonOlder
=======
, fetchPypi
, isPy27
, pytest
, jdcal
, et_xmlfile
, lxml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "openpyxl";
<<<<<<< HEAD
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "openpyxl";
    repo = "openpyxl";
    rev = version;
    hash = "sha256-SWRbjA83AOLrfe6on2CSb64pH5EWXkfyYcTqWJNBEP0=";
  };

  propagatedBuildInputs = [
    jdcal
    et_xmlfile
    lxml
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "openpyxl"
  ];

  meta = with lib; {
    description = "Python library to read/write Excel 2010 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    changelog = "https://foss.heptapod.net/openpyxl/openpyxl/-/blob/${version}/doc/changes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
=======
  version = "3.1.1";
  disabled = isPy27; # 2.6.4 was final python2 release

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8G1E4slzeBBovOXs+GCgm82xx/XOH6zV6aqCySyTrnI=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ jdcal et_xmlfile lxml ];

  postPatch = ''
    # LICENSE.rst is missing, and setup.cfg currently doesn't contain anything useful anyway
    # This should likely be removed in the next update
    rm setup.cfg
  '';

  # Tests are not included in archive.
  # https://bitbucket.org/openpyxl/openpyxl/issues/610
  doCheck = false;

  meta = {
    description = "A Python library to read/write Excel 2007 xlsx/xlsm files";
    homepage = "https://openpyxl.readthedocs.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
