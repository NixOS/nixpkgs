{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "markupsafe";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
    sha256 = "sha256-f5EZfMnkj5idEuTm+8RklcRGY238gbnM9Quw7HS5HUs=";
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
