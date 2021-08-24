{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, markdown-it-py
, poetry-core
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mdformat";
  version = "0.7.9";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = version;
    sha256 = "sha256-qGRZCDo/ACSXtJa4omepjaR0KNWeR4vvvUUbQpKlrtI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    markdown-it-py
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mdformat" ];

  meta = with lib; {
    description = "CommonMark compliant Markdown formatter";
    homepage = "https://mdformat.rtfd.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
