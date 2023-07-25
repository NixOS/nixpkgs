{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
, rich
, typer
}:

buildPythonPackage rec {
  pname = "rich-click";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ewels";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Be6okg3zmbdbdlB4/uwioUxn6CZUay/istiIoiFrsJk=";
  };

  propagatedBuildInputs = [
    click
    rich
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
