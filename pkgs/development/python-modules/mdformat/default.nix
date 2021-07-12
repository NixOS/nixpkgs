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
  version = "0.7.7";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = version;
    sha256 = "sha256-1qwluHxZnSuyNJENzeJzkuhIQN5njTOch2Wz45J0qRI=";
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
