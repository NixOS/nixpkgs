{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bitmath";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timlnx";
    repo = "bitmath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9hiwIpDIAU+N+LhlJ9qlKBZQibbrwwhGM77fvEnABRI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bitmath" ];

  meta = {
    description = "Module for representing and manipulating file sizes with different prefix";
    homepage = "https://github.com/timlnx/bitmath";
    changelog = "https://github.com/timlnx/bitmath/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
    mainProgram = "bitmath";
  };
})
