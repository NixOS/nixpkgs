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
  version = "1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WDfktW8jxh3blr0BH2p6z/Pl6VkQuLqiC5+akYnhaV4=";
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
