{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  apispec,
  flask,
  marshmallow,
  pyyaml,
  webargs,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-smorest";
  version = "0.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-smorest";
    tag = finalAttrs.version;
    hash = "sha256-fznW4wVLjmGHXHciXES7SBU/ImuY8//8vpQIY9gUyv0=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    apispec
    flask
    marshmallow
    webargs
    werkzeug
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ]
  ++ flask.optional-dependencies.async;

  pythonImportsCheck = [ "flask_smorest" ];

  meta = {
    description = "DB agnostic framework to build auto-documented REST APIs with Flask and marshmallow";
    homepage = "https://flask-smorest.readthedocs.io";
    changelog = "https://github.com/marshmallow-code/flask-smorest/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
