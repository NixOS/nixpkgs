{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pyleri";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cesbit";
    repo = "pyleri";
    rev = "refs/tags/${version}";
    hash = "sha256-4t+6wtYzJbmL0TB/OXr89uZ2s8DeGlUdWwHd4YPsCW0=";
  };

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "pyleri"
  ];

  meta = with lib; {
    description = "Module to parse SiriDB";
    homepage = "https://github.com/cesbit/pyleri";
    changelog = "https://github.com/cesbit/pyleri/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
