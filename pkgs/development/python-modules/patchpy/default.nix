{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "patchpy";
  version = "2.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-q+k9vYz5crCsBjI5QH7Xz3QVpntzrIXeO456dyrzf4I=";
  };

  build-system = [ hatchling ];

  dependencies = [ more-itertools ];

  pythonImportsCheck = [ "patchpy" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Modern Python library for patch file parsing";
    homepage = "https://github.com/MatthewScholefield/patchpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "patchpy";
  };
})
