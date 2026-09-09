{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  uv-build,
  unidata-blocks,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pixel-font-knife";
  version = "0.0.25";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pixel-font-knife";
    tag = version;
    hash = "sha256-KQN4FQf6PsNi+NQW0BOD4tuK4G5LkUgP6Cr2drUpLO0=";
  };

  build-system = [ uv-build ];

  dependencies = [
    unidata-blocks
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pixel_font_knife" ];

  meta = {
    homepage = "https://github.com/TakWolf/pixel-font-knife";
    description = "Set of pixel font utilities";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
