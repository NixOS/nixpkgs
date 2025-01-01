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
  version = "1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iP9QVyAvKMTo8GuceiXWALmWKQ9yLX2qxl0S7IT+kMA=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    manifestoo-core
    textual
    typer
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
