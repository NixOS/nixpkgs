{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, markdown-it-py
, poetry-core
, pytestCheckHook
, pythonOlder
, tomli
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mdformat";
  version = "0.7.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = version;
    sha256 = "sha256-Zw7ZGV/Hd0MRxxQVwkjtE6MJXNLQ0A0PJlQr4x9h2ww=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    markdown-it-py
    tomli
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
