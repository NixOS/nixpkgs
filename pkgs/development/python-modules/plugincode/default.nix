{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, click
, commoncode
, pluggy
, pytestCheckHook
, pytest-xdist
}:
buildPythonPackage rec {
  pname = "plugincode";
  version = "21.1.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97b5a2c96f0365c80240be103ecd86411c68b11a16f137913cbea9129c54907a";
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

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [
    "plugincode"
  ];

  meta = with lib; {
    description = "A library that provides plugin functionality for ScanCode toolkit";
    homepage = "https://github.com/nexB/plugincode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
