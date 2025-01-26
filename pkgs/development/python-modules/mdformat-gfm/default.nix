{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  linkify-it-py,
  markdown-it-py,
  mdformat,
  mdformat-tables,
  mdit-py-plugins,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-gfm";
  version = "0.3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "mdformat-gfm";
    tag = version;
    hash = "sha256-c1jJwyTL8IgQnIAJFoPSuJ8VEYgnQ4slZyV0bHlUHLQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    markdown-it-py
    mdformat
    mdformat-tables
    mdit-py-plugins
    linkify-it-py
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_default_style__api"
    "test_default_style__cli"
  ];

  pythonImportsCheck = [ "mdformat_gfm" ];

  meta = with lib; {
    description = "Mdformat plugin for GitHub Flavored Markdown compatibility";
    homepage = "https://github.com/hukkin/mdformat-gfm";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      polarmutex
    ];
  };
}
