{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vuls";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "future-architect";
    repo = "vuls";
    rev = "refs/tags/v${version}";
    hash = "sha256-mrptQSTxTdste6UgbkAm3aqgpYfaoOykHX0eYOTojgA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-KufQPVnNRoyaHiuVaVIjwifh5CsoCoF7CrqvBKcG7kA=";

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
