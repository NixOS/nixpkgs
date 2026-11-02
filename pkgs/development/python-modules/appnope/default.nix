{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "appnope";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "minrk";
    repo = "appnope";
    tag = finalAttrs.version;
    hash = "sha256-saJ68R4zdquTWWT/QuWZk6oQhcx3R+AmVBYt/NmFtyM=";
  };

  build-system = [ hatchling ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "appnope" ];

  meta = {
    description = "Disable App Nap on macOS";
    homepage = "https://github.com/minrk/appnope";
    changelog = "https://github.com/minrk/appnope/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    # Not Darwin-specific because dummy fallback may be used cross-platform
  };
})
