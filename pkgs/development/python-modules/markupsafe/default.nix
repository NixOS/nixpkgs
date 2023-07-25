{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "markupsafe";
  version = "2.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
    hash = "sha256-r1mO0y1q6G8bdHuCeDlYsaSrj2F7Bv5oeVx/Amq73K0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "markupsafe" ];

  meta = with lib; {
    changelog = "https://markupsafe.palletsprojects.com/en/${versions.majorMinor version}.x/changes/#version-${replaceStrings [ "." ] [ "-" ] version}";
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "https://palletsprojects.com/p/markupsafe/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
