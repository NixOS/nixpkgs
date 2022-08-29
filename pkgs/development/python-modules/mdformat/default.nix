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
  version = "0.7.16";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = version;
    sha256 = "sha256-6MWUkvZp5CYUWsbMGXM2gudjn5075j5FIuaNnCrgRNs=";
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

  disabledTests = [
    # AssertionError
    "test_no_codeblock_trailing_newline"
    # Issue with upper/lower case
    "default_style.md-options0"
  ];

  pythonImportsCheck = [
    "mdformat"
  ];

  meta = with lib; {
    description = "CommonMark compliant Markdown formatter";
    homepage = "https://mdformat.rtfd.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
