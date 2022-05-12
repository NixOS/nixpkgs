{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yaHw/pOqWLUtYoM3l/JB0JToLXdi04n0BSccRdbCVDw=";
  };

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [
    "puremagic"
  ];

  meta = with lib; {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
