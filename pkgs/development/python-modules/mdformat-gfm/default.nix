{ lib
, buildPythonPackage
, fetchFromGitHub
, linkify-it-py
, markdown-it-py
, mdformat
, mdformat-tables
, mdit-py-plugins
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-gfm";
  version = "0.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = "735781e3fcf95d92cd4537a9712893d00415cd63";
    hash = "sha256-dQsYL2I3bWmdgoxIHhW6e+Sz8kfjD1bR5XZmpmUYCV8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    mdformat
    markdown-it-py
    mdit-py-plugins
  ];

  propagatedBuildInputs = [
    mdformat-tables
    linkify-it-py
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_default_style__api"
    "test_default_style__cli"
  ];

  pythonImportsCheck = [
    "mdformat_gfm"
  ];

  meta = with lib; {
    description = "Mdformat plugin for GitHub Flavored Markdown compatibility";
    homepage = "https://github.com/hukkin/mdformat-gfm";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero polarmutex ];
  };
}
