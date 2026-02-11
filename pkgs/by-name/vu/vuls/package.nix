{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vuls";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BkFFFo0+5f2OmxlleUaqsoX8gesytXGHuSwLTnTJnV0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-fyuY0GbdZpBw7nbPIZqLakRwOCHQLaEeuihtkIGOzzU=";

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
