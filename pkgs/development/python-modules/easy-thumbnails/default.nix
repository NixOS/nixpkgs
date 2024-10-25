{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  pillow,
  pythonOlder,
  reportlab,
  svglib,
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0AlGL815Ht8kluXtRtBEcS4aBrfUYA5M8oEgAumQTvU=";
  };

  propagatedBuildInputs = [
    django
    pillow
    svglib
    reportlab
  ];

  # Tests require a Django instance which is setup
  doCheck = false;

  pythonImportsCheck = [ "easy_thumbnails" ];

  meta = with lib; {
    description = "Easy thumbnails for Django";
    homepage = "https://github.com/SmileyChris/easy-thumbnails";
    changelog = "https://github.com/SmileyChris/easy-thumbnails/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
