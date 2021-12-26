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
  version = "2.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd2249d936671847fc54a2d6c8c87bcca8f803001967dd03bab6b8bcb7590825";
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
