{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gamble";
  version = "0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zsEBqhKidgO1e0lpKhw+LY75I2Df+IefNLaSkBBFKFU=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gamble"
  ];

  meta = with lib; {
    description = "Collection of gambling classes/tools";
    homepage = "https://github.com/jpetrucciani/gamble";
    changelog = "https://github.com/jpetrucciani/gamble/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
