{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mtranslate";
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mouuff";
    repo = "mtranslate";
    tag = finalAttrs.version;
    hash = "sha256-vzY//hIVZEZtNoJku+atKKIMmr/0CQVmfbg2AN5KKyY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mtranslate" ];

  # Module has no unit tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module to interact with the API for Google translate";
    homepage = "https://github.com/mouuff/mtranslate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
