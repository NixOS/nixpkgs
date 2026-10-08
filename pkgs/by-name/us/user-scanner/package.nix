{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "user-scanner";
  version = "1.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kaifcodec";
    repo = "user-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lBVKCIpvdYRz80BoaSbFcizs2tLEWankcLeOqu9u4iM=";
  };

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    colorama
    curl-cffi
    httpx
    mcp
    socksio
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

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
