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
  version = "31.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0BfdHQn/Kgct4ZT34KhMgMC3nS0unE3iL7DiWDhXDSk=";
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
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
