{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  flask,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-htmx";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "edmondchuc";
    repo = "flask-htmx";
    tag = finalAttrs.version;
    hash = "sha256-MGcU/SDoOtteN/et7vdwE2oogm/mRJAcAGn6tYqj9OY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ flask ];

  pythonImportsCheck = [ "flask_htmx" ];

  meta = {
    description = "Flask extension for working with HTMX";
    homepage = "https://github.com/edmondchuc/flask-htmx";
    changelog = "https://github.com/edmondchuc/flask-htmx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
