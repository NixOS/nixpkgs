{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flask,
  werkzeug,
  pytestCheckHook,
  setuptools,
  setuptools-scm,

  # for passthru.tests
  aiobotocore,
  moto,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-cors";
  version = "6.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corydolphin";
    repo = "flask-cors";
    tag = finalAttrs.version;
    hash = "sha256-fngKJm7/7BMcWPPFncTCWw2sL1UJ0t4ICpXr95yNpbg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    flask
    werkzeug
  ];

  pythonImportsCheck = [ "flask_cors" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit aiobotocore moto;
  };

  meta = {
    description = "Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    changelog = "https://github.com/corydolphin/flask-cors/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
