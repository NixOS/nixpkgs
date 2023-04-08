{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "markupsafe";
  version = "2.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
    hash = "sha256-q8q8jCsmA21i1MdGOBpvfPYKr8xlMZitZ4MGmGsJRQ0=";
  };

  nativeCheckInputs = [
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
