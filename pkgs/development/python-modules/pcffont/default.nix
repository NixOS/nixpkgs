{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  hatchling,
  bdffont,
}:

buildPythonPackage rec {
  pname = "pcffont";
  version = "0.0.15";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "pcffont";
    inherit version;
    hash = "sha256-sJWopdjZ0vM0BrdBgc6XZsDGFN7/NCCBqrCyYCRhT3M=";
  };

  build-system = [ hatchling ];

  dependencies = [ bdffont ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pcffont" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pcffont";
    description = "A library for manipulating Portable Compiled Format (PCF) Fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
