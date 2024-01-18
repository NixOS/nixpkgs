{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
, rich
, setuptools
, typer
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rich-click";
  version = "1.7.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ewels";
    repo = "rich-click";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZTUJbW39SBaqgVG+ytmnPG6DK7J2XGPwmC2w3TCodBo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
