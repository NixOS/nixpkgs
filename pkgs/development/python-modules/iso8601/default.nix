{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "0.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8aafd56fa0290496c5edbb13c311f78fa3a241f0853540da09d9363eae3ebd79";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "iso8601" ];

  pythonImportsCheck = [ "iso8601" ];

  meta = with lib; {
    description = "Simple module to parse ISO 8601 dates";
    homepage = "https://pyiso8601.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
