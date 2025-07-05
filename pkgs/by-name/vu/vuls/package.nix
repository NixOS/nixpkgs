{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module rec {
  pname = "vuls";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    tag = "v${version}";
    hash = "sha256-djs4bhdicZFDETw3tLoks7KKjLh/o6Z6Ivzw0I/VxH8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-1W6xI6rRyaSfryNZSGhgHULotZ42lPsDt27KVzFEhog=";

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
