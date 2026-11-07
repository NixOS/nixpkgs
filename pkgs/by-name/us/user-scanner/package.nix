{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # Necessary until user-scanner works with mcp 2.x
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "user-scanner";
  version = "1.5.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kaifcodec";
    repo = "user-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jg40VMWEL7dW67M45S35phiVHygZUxcM9CmIT7WWdDY=";
  };

  build-system = with pythonPackages; [ flit-core ];

  dependencies = with pythonPackages; [
    colorama
    curl-cffi
    httpx
    mcp
    socksio
  ];

  nativeCheckInputs = with pythonPackages; [ pytestCheckHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  pythonImportsCheck = [ "user_scanner" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Email & Username OSINT suite";
    homepage = "https://github.com/kaifcodec/user-scanner";
    changelog = "https://github.com/kaifcodec/user-scanner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "user-scanner";
  };
})
