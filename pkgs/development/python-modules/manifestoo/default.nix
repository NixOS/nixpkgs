{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  importlib-metadata,
  manifestoo-core,
  nix-update-script,
  pytestCheckHook,
  pythonOlder,
  textual,
  typer,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "manifestoo";
  version = "0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gCGchc+fShBgt6fVJAx80+QnH+vxWo3jsIyePkFwhYE=";
  };

  build-system = [ hatch-vcs ];

  propagatedBuildInputs =
    [
      manifestoo-core
      textual
      typer
    ]
    ++ typer.optional-dependencies.standard ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "manifestoo" ];

  meta = with lib; {
    description = "A tool to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo";
    changelog = "https://github.com/acsone/manifestoo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
