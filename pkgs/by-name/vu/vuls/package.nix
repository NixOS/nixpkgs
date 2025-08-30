{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module rec {
  pname = "vuls";
  version = "0.33.4";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${version}";
    hash = "sha256-FPI62wuDcriNMCPkzEZXSlfpCwpQhw0QiZUAJ4OFgic=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-OjE+j91QgS74FknfYLnkA7RKDSnC8yUZDIRXw3taORA=";

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
