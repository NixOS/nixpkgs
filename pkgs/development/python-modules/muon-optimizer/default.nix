{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  nix-update-script,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "muon-optimizer";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "muon_optimizer";
    inherit (finalAttrs) version;
    hash = "sha256-ZcUEQfKbckjlhjg9NxJi65BiZT6CCxEUPIGnoQukjac=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "muon"
  ];

  dependencies = [
    torch
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Optimizer for the hidden layers of neural networks";
    homepage = "https://pypi.org/project/muon-optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
