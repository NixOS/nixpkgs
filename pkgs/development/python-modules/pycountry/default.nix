{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "20.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hnbabsmqimx5hqh0jbd2f64i8fhzhhbrvid57048hs5sd9ll241";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycountry"
  ];

  meta = with lib; {
    homepage = "https://github.com/flyingcircusio/pycountry";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };

}
