{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, poetry-core
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "newversion";
  version = "1.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = pname;
    rev = version;
    hash = "sha256-27HWMzSzyAbiOW7OUhlupRWIVJG6DrpXObXmxlCsmxU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
