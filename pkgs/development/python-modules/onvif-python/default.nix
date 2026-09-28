{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  requests,
  setuptools,
  zeep,
}:

buildPythonPackage (finalAttrs: {
  pname = "onvif-python";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nirsimetri";
    repo = "onvif-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DLjiu6/o3iBcQjKlSAgDjd4FYfz2A3yDYZ84j8kMyzM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    zeep
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "onvif" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for ONVIF-compliant devices";
    homepage = "https://github.com/nirsimetri/onvif-python";
    changelog = "https://github.com/nirsimetri/onvif-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
