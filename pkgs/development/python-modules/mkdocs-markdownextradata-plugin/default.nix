{ lib
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, pytestCheckHook
, pythonOlder
, pyyaml
, click
}:

buildPythonPackage rec {
  pname = "mkdocs-markdownextradata-plugin";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rosscdh";
    repo = "mkdocs-markdownextradata-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-wXk3xV+7xwN4udGNAKFR4C/q8hJS7k18XJJxxFmUR5A=";
  };

  propagatedBuildInputs = [
    mkdocs
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    click
    pyyaml
  ];

  pythonImportsCheck = [
    "markdownextradata"
  ];

  meta = with lib; {
    description = "A MkDocs plugin that injects the mkdocs.yml extra variables into the markdown template";
    homepage = "https://github.com/rosscdh/mkdocs-markdownextradata-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
