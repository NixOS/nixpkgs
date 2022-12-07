{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gamble";
  version = "0.11";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zsEBqhKidgO1e0lpKhw+LY75I2Df+IefNLaSkBBFKFU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gamble"
  ];

  meta = with lib; {
    description = "Collection of gambling classes/tools";
    homepage = "https://github.com/jpetrucciani/gamble";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
