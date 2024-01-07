{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
, rich
, typer
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rich-click";
  version = "1.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ewels";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uPEPYQIoLdjUJZlcg/0jenzIz464nwGi5KfOOyIQ/3I=";
  };

  propagatedBuildInputs = [
    click
    rich
    typing-extensions
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "rich_click"
  ];

  meta = with lib; {
    description = "Module to format click help output nicely with rich";
    homepage = "https://github.com/ewels/rich-click";
    changelog = "https://github.com/ewels/rich-click/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
