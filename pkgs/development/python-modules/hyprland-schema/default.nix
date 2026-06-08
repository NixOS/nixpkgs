{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-schema";
  version = "0.6.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-schema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w0fWQkSziNYZtgtqm1El5fP+fCmFMpMf21uo9cf/vqA=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_schema" ];

  # test_generate.py requires network access to fetch Hyprland source
  doCheck = false;

  meta = {
    description = "Typed Python schema for every Hyprland configuration option";
    homepage = "https://github.com/BlueManCZ/hyprland-schema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
