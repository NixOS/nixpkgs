{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "22.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9a6d9cdbf53f81ccdf73f6f5de01b0d8493cab2213a230af3e34458de85ea32";
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
