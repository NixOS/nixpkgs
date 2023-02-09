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
  version = "2.8.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fk6RJgn8m2Czof72VX7BXd+cT5RiZ6kuaSDf1N12XjU=";
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
    changelog = "https://github.com/SmileyChris/easy-thumbnails/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
