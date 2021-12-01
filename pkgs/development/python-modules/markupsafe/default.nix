{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "markupsafe";
  version = "2.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
    sha256 = "02k2ynmqvvd0z0gakkf8s4idyb606r7zgga41jrkhqmigy06fk2r";
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
