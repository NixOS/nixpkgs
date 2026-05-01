{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vuls";
  version = "0.38.6";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DY2woiaA6RisbOmHMoIr3sLn2kEccru58LGtST/iY3E=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-s2N6MCcqMfwjW095iwOv8hHcrB6NC6XSkrtdSGWq8bE=";

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
