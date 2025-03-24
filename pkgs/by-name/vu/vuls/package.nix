{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module rec {
  pname = "vuls";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${version}";
    hash = "sha256-lDLT5GNFL2LtooHNlpKrewzxVK5W8u+0U47BDvMG8l4=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-X9PWg4vB07Bh9w8Lw3cdEaciVvRhvQD0L5n4cFKf880=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/future-architect/vuls/config.Version=${version}"
    "-X=github.com/future-architect/vuls/config.Revision=${src.rev}-1970-01-01T00:00:00Z"
  ];

  postFixup = ''
    mv $out/bin/cmd $out/bin/trivy-to-vuls
  '';

  meta = {
    description = "Agent-less vulnerability scanner";
    homepage = "https://github.com/future-architect/vuls";
    changelog = "https://github.com/future-architect/vuls/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vuls";
  };
}
