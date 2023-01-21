{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s5+/rHJhj6HutbP9ntE0HxDdkN91SZy0w4psPvR83ZQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prefixed"
  ];

  meta = with lib; {
    description = "Prefixed alternative numeric library";
    homepage = "https://github.com/Rockhopper-Technologies/prefixed";
    changelog = "https://github.com/Rockhopper-Technologies/prefixed/releases/tag/${version}";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
