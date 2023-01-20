{ lib
, buildPythonPackage
, fetchPypi
, kicad
, versioneer
}:

buildPythonPackage rec {
  pname = "pcbnew-transition";
  version = "0.3.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "pcbnewTransition";
    inherit version;
    hash = "sha256-3CJUG1kd63Lg0r9HpJRIvttHS5s2EuZRoxeXrqsJ/kQ=";
  };

  propagatedBuildInputs = [ kicad ];

  buildInputs = [ versioneer ];

  pythonImportsCheck = [
    "pcbnewTransition"
  ];

  meta = with lib; {
    description = "Library that allows you to support both KiCAD 5 and KiCAD 6 in your plugins";
    homepage = "https://github.com/yaqwsx/pcbnewTransition";
    license = licenses.mit;
    maintainers = with maintainers; [ tmarkus ];
  };
}
