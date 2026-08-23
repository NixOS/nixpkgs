{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "yatas";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "padok-team";
    repo = "YATAS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fkMrQqHtlZWoJZgSu1KeZ+p1pWXFUYYIUOkvd/DHx8k=";
  };

  vendorHash = "sha256-NJO/eankcoM9FsYz7jop1tY0ueeNyVG2TEip5F46haI=";

  meta = {
    description = "Tool to audit AWS infrastructure for misconfiguration or potential security issues";
    homepage = "https://github.com/padok-team/YATAS";
    changelog = "https://github.com/padok-team/YATAS/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yatas";
  };
})
