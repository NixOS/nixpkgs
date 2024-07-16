{
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  importlib-metadata,
  lib,
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
  version = "1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iP9QVyAvKMTo8GuceiXWALmWKQ9yLX2qxl0S7IT+kMA=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs =
    [
      manifestoo-core
      textual
      typer
    ]
    ++ typer.passthru.optional-dependencies.all
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
