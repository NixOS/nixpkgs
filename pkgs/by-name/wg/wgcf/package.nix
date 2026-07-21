{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgcf";
  version = "2.2.31";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G/qyCc43tjcWtR/GD0DtTq3TZY4MmitQhTQbpruhCKw=";
  };

  subPackages = ".";

  vendorHash = "sha256-0KuMWUHxfnfj60PR02JQ9Ajk4czC9ggUVEspOxH8JQk=";

  meta = {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
})
