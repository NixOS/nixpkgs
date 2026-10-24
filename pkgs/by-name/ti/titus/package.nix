{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  gitMinimal,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "titus";
  version = "1.2.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "titus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z8flufvaUI+eA9PpYJihE3afZX1ZmvcnV9LORWVeNHc=";
  };

  vendorHash = "sha256-1kJeOd9laPbGBQP4hDKg5t4rVy0NqUG4QZj9LupV7+c=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    gitMinimal
    makeWrapper
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  postFixup = ''
    wrapProgram $out/bin/titus --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool to scan for secrets";
    homepage = "https://github.com/praetorian-inc/titus";
    changelog = "https://github.com/praetorian-inc/titus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "titus";
  };
})
