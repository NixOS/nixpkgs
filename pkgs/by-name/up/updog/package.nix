{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "updog";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sc0tfree";
    repo = "updog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EFAqxlKrQ9HBMHBdmstY+RZPqK0kWY5Ws6WMFHlMyM0=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    colorama
    flask
    flask-cors
    flask-httpauth
    pyopenssl
    werkzeug
  ];

  pythonRelaxDeps = [
    "pyopenssl"
    "flask-cors"
  ];

  nativeCheckInputs = [ versionCheckHook ];

  # no python tests

  meta = {
    description = "Replacement for Python's SimpleHTTPServer";
    mainProgram = "updog";
    homepage = "https://github.com/sc0tfree/updog";
    changelog = "https://github.com/sc0tfree/updog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
