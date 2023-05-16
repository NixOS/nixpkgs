{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, click
, commoncode
, pluggy
, pytestCheckHook
, pytest-xdist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plugincode";
<<<<<<< HEAD
  version = "32.0.0";
=======
  version = "31.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-QTLZOxdVJxxuImydouIET/YuvLhztelY1mqN3enzRfo=";
=======
    hash = "sha256-0BfdHQn/Kgct4ZT34KhMgMC3nS0unE3iL7DiWDhXDSk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    commoncode
    pluggy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [
    "plugincode"
  ];

  disabledTests = [
    # We don't want black as an input
    "test_skeleton_codestyle"
  ];

  meta = with lib; {
    description = "Library that provides plugin functionality for ScanCode toolkit";
    homepage = "https://github.com/nexB/plugincode";
<<<<<<< HEAD
    changelog = "https://github.com/nexB/plugincode/blob/v${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = [ ];
  };
}
