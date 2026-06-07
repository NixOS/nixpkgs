{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  kicad,
  versioneer,
}:
buildPythonPackage (finalAttrs: {
  pname = "pcbnewtransition";
  version = "0.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zLnvbu0G2mJKCHLCjbIKHBqSfdEyhR+1afkOFU++TfI=";
  };

  build-system = [ setuptools ];
  dependencies = [ kicad ];

  nativeBuildInputs = [ versioneer ];

  pythonImportsCheck = [ "pcbnewTransition" ];

  meta = {
    description = "Library that allows you to support both, KiCad 5, 6 and 7 in your plugins";
    homepage = "https://github.com/yaqwsx/pcbnewTransition";
    changelog = "https://github.com/yaqwsx/pcbnewTransition/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jfly
      matusf
    ];
  };
})
