{ lib
, buildPythonPackage
, cffi
, fetchPypi
, zope-interface
, sphinx
, manuel
, pythonOlder
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pfkeAJD5OS/TJNl/TCpjbJI5lYKCOM2i4/vMaxu8RoY=";
  };

  nativeBuildInputs = [
    sphinx
    manuel
  ];

  propagatedBuildInputs = [
    zope-interface
    cffi
  ];

  pythonImportsCheck = [
    "persistent"
  ];

  meta = with lib; {
    description = "Automatic persistence for Python objects";
    homepage = "https://github.com/zopefoundation/persistent/";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
