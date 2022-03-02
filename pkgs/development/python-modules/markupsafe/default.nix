{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "markupsafe";
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
    sha256 = "sha256-gL6vY937xkoEUrhB2ANsoGEeBJZQ4gr8uIL108Jm1l8=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "markupsafe" ];

  meta = with lib; {
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "https://palletsprojects.com/p/markupsafe/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
