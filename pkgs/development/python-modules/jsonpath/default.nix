{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jsonpath";
<<<<<<< HEAD
  version = "0.82.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2H7yvLze1o7pa8NMGAm2lFfs7JsMTdRxZYoSvTkQAtE=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonpath"
  ];

  pytestFlagsArray = [
    "test/test*.py"
  ];

=======
  version = "0.82";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46d3fd2016cd5b842283d547877a02c418a0fe9aa7a6b0ae344115a2c990fef4";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "An XPath for JSON";
    homepage = "https://github.com/json-path/JsonPath";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ mic92 ];
=======
    maintainers = [ maintainers.mic92 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
