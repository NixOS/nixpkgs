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
  version = "25.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pelme";
    repo = "htpy";
    tag = version;
    hash = "sha256-s26I+eMue49+pIHe3dHnxMLJ/oGvs1ERZtcCR65Z8Is=";
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
