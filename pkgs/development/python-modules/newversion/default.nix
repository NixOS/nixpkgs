{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "newversion";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = "newversion";
    rev = "refs/tags/${version}";
    hash = "sha256-v9hfk2/hBkWtOobQdaYXNOZTTcEqnMV6JYqtjjoidOs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "newversion"
  ];

  meta = with lib; {
    description = "PEP 440 version manager";
    homepage = "https://github.com/vemel/newversion";
    changelog = "https://github.com/vemel/newversion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
