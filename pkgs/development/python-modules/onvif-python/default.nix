{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  requests,
  setuptools,
  writableTmpDirAsHomeHook,
  zeep,
}:

buildPythonPackage (finalAttrs: {
  pname = "onvif-python";
  version = "0.4.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nirsimetri";
    repo = "onvif-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-srLi8RzEqbV2Qre78d2QvGXXaqzuirhBOAT0wJkPzZE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "wheel>=0.48.0,<1.0.0" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    zeep
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

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
