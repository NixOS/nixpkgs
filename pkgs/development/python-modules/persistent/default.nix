{ lib
, buildPythonPackage
, cffi
, fetchPypi
, zope_interface
, sphinx
, manuel
, pythonOlder
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-piFSIf6zlV1IX6kMe87E+yllDOOco9DBEmcQOS4Nwtw=";
  };

  nativeBuildInputs = [
    sphinx
    manuel
  ];

  propagatedBuildInputs = [
    zope_interface
    cffi
  ];

  pythonImportsCheck = [
    "persistent"
  ];

  meta = with lib; {
    description = "Automatic persistence for Python objects";
    homepage = "https://github.com/zopefoundation/persistent/";
    changelog = "https://github.com/zopefoundation/persistent/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
