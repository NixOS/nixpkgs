{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-tryton";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "hatch_tryton";
    inherit (finalAttrs) version;
    hash = "sha256-0NccQKXyC811K+90Pn1xPBUASQ/zzAripwnv9jnpA0U=";
  };

  build-system = [ hatchling ];

  buildInputs = [ hatchling ];

  pythonImportsCheck = [ "hatch_tryton" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hatchling plugin for Tryton";
    homepage = "https://pypi.org/project/hatch-tryton";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
