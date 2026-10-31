{
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  lib,
  manifestoo-core,
  nix-update-script,
  pytestCheckHook,
  textual,
  typer,
}:

buildPythonPackage rec {
  pname = "manifestoo";
  version = "1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3A8N7Ub3gKI1kFIY8hs+SSzzwrJKW/RJDy82K7pfR7w=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    manifestoo-core
    textual
    typer
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
