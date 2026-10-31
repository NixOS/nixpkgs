{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  flask,
  flask-wtf,
  wtforms_3_3,
  wtforms-htmx,
  pytestCheckHook,
  pytest-xdist,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-wtforms-htmx";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yaal-coop";
    repo = "flask-wtforms-htmx";
    tag = finalAttrs.version;
    hash = "sha256-jxTNjmGkBDzYVNKXO7Y44wBfc8DHwgKg4FJ9kLvKE2Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.13.1,<0.14' 'uv_build'
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    flask
    (flask-wtf.override { wtforms = wtforms_3_3; })
    wtforms-htmx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [
    "flask_wtforms_htmx"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A drop-in FlaskForm that brings wtforms-htmx to Flask-WTF";
    homepage = "https://github.com/yaal-coop/flask-wtforms-htmx";
    changelog = "https://github.com/yaal-coop/flask-wtforms-htmx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
