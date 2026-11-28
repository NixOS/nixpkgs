{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tgread";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wjkoh";
    repo = "tgread";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gYGZkl/QJWj00mRuaQ8XC1J7kNKiZd9Lp5eBIH1bomE=";
  };

  vendorHash = "sha256-BvuHOD8/T1lnyzTPk4k5sACux8tQZ33NAkZnBOA/zwI=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal, compile-time read-only Telegram MTProto MCP server and CLI";
    homepage = "https://github.com/wjkoh/tgread";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wjkoh ];
    mainProgram = "tgread";
  };
})
