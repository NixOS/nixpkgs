{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttfx";
  version = "0.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "ttfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZeWRyo9zturjRcH23SDgFOKoPOSY6nGMFzGeJAoDapk=";
  };

  cargoHash = "sha256-ntoj5bmAa9U2+3K1UX6HL0t6MjfCYQNe5LuiuNJ/CnY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal text effects engine as a standalone CLI";
    homepage = "https://github.com/omacom/ttfx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "ttfx";
  };
})
