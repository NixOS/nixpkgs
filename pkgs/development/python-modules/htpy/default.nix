{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  markupsafe,
  pytestCheckHook,
  django,
  flask,
  starlette,
  httpx,
  black,
  ruff,
  markdown,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "htpy";
  version = "25.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pelme";
    repo = "htpy";
    tag = version;
    hash = "sha256-shrp/3rvmPj0HDcNOnCNtAOrhF/bT3j8MCFBb8pImYE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    markupsafe
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    django
    flask
    starlette
    httpx
    black
    ruff
    markdown
  ];

  pythonImportsCheck = [ "htpy" ];

  meta = {
    mainProgram = "html2htpy";
    description = "Generate HTML in Python without a template language";
    license = lib.licenses.mit;
    homepage = "https://htpy.dev";
    maintainers = with lib.maintainers; [ dunderrrrrr ];
  };
}
