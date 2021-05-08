{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, CommonMark
, colorama
, dataclasses
, ipywidgets
, poetry-core
, pygments
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rich";
  version = "10.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HH+k9uiK34yoqu83rknCIe2DpoqJRHkcqABuj8zjzqs=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    CommonMark
    colorama
    ipywidgets
    pygments
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rich" ];

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/willmcgugan/rich";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
