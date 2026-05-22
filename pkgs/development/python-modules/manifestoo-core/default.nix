{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "manifestoo-core";
  version = "1.15.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "manifestoo_core";
    hash = "sha256-cneTeLVamKknBPSZSnd+6ks2D7W2HDv6PLqCeMZJ4Gg=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/acsone/manifestoo-core/blob/v${version}/HISTORY.rst";
    description = "Library to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo-core";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
