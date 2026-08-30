{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytak,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiscot";
  version = "7.1.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snstac";
    repo = "aiscot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BZwDKVyF0AJVCq3YrMiX0PQjfpGMTBpTsQzqXGDBo8M=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytak ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiscot" ];

  meta = {
    description = "Display Ships in TAK - AIS to TAK Gateway";
    homepage = "https://github.com/snstac/aiscot";
    changelog = "https://github.com/snstac/aiscot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
