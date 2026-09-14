{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vuls";
  version = "0.40.1";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IWCdSejQvVu3vkekanuGByKNGmtnhuG8DKBwbGciHi0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-Whxh5xtM+WCd/ynqqm3hutx69sLKnZqaTZJwtlFt7Tk=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/future-architect/vuls/config.Version=${finalAttrs.version}"
    "-X=github.com/future-architect/vuls/config.Revision=${finalAttrs.src.rev}-1970-01-01T00:00:00Z"
  ];

  postFixup = ''
    mv $out/bin/cmd $out/bin/trivy-to-vuls
  '';

  meta = {
    description = "Agent-less vulnerability scanner";
    homepage = "https://github.com/future-architect/vuls";
    changelog = "https://github.com/future-architect/vuls/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vuls";
  };
})
