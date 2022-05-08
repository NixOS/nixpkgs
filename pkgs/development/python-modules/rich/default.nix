{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, CommonMark
, dataclasses
, poetry-core
, pygments
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rich";
  version = "12.4.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ryJTusUNpvNF2031ICJWK8ScxHIh+LrXYg7nd0ph4aQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    CommonMark
    pygments
  ] ++ lib.optional (pythonOlder "3.7") [
    dataclasses
  ] ++ lib.optional (pythonOlder "3.9") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rich" ];

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
