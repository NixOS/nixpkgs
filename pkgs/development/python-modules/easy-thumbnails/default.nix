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
  version = "2.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a283fe8a3569c3feab4605e8279929d75c85c1151b2fd627f95b1863b5fc6c2";
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
