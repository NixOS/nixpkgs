{ lib
, buildPythonPackage
, django
, fetchPypi
, pillow
, pytestCheckHook
, pythonOlder
, reportlab
, svglib
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ij7GG7jHL6x/degRqW4815QqyJyrVasWVJ1tLOnN6qU=";
  };

  propagatedBuildInputs = [
    django
    pillow
    svglib
    reportlab
  ];

  # Tests require a Django instance which is setup
  doCheck = false;

  pythonImportsCheck = [
    "easy_thumbnails"
  ];

  meta = with lib; {
    description = "Easy thumbnails for Django";
    homepage = "https://github.com/SmileyChris/easy-thumbnails";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
