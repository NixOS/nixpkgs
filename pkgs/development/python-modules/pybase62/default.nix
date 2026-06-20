{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybase62";
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suminb";
    repo = "base62";
    tag = finalAttrs.version;
    hash = "sha256-/H16MT3mKCdXItoeOn1LWTHlgWmtwJdQHUaCp18eMz0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "base62" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module for base62 encoding";
    homepage = "https://github.com/suminb/base62";
    changelog = "https://github.com/suminb/base62/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2WithViews;
    maintainers = with lib.maintainers; [ fab ];
  };
})
