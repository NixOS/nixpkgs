{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  hatch-vcs,
}:

buildPythonPackage (finalAttrs: {
  pname = "manifestoo-core";
  version = "1.16.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "manifestoo_core";
    hash = "sha256-T1yE+ydFvuUVek0fLwnBvt6nrXSEnUKvj+4dsgBFLs8=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/acsone/manifestoo-core/blob/v${finalAttrs.version}/HISTORY.rst";
    description = "Library to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo-core";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
})
