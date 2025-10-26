{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "manifestoo-core";
  version = "1.14";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "manifestoo_core";
    hash = "sha256-gjKkP+mYitpjDNqT3GZTQJzVtXmcl/0d0/LCk73B2h8=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo-core";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
