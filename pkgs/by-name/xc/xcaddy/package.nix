{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "xcaddy";
  version = "0.4.7";

  __structuredAttrs = true;

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "xcaddy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q69Ey6gf/Uyui9x3nKkGFHiwTpMB0N3ix89JLgTsR1A=";
  };

  ldflags = [
    "-s"
    "-X github.com/caddyserver/xcaddy/cmd.CustomVersion=v${finalAttrs.version}"
  ];

  vendorHash = "sha256-bZs+2XrwVwfJdNLBZk6FPNi26ctVQ82ywesEU0o5Gkc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/caddyserver/xcaddy";
    description = "Build Caddy with plugins";
    mainProgram = "xcaddy";
    license = lib.licenses.asl20;
  };
})
