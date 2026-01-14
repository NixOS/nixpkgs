{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "teler";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "teler";
    tag = "v${version}";
    hash = "sha256-3+A1QloZQlH31snWfwYa6rprpKUf3fQc/HQgmKQgV9c=";
  };

  vendorHash = "sha256-gV/PJFcANeYTYUJG3PYNsApYaeBLx76+vVBvcuKDYO4=";

  ldflags = [
    "-s"
    "-w"
    "-X=ktbs.dev/teler/common.Version=${version}"
  ];

  # test require internet access
  doCheck = false;

  meta = {
    description = "Real-time HTTP Intrusion Detection";
    longDescription = ''
      teler is an real-time intrusion detection and threat alert
      based on web log that runs in a terminal with resources that
      we collect and provide by the community.
    '';
    homepage = "https://github.com/kitabisa/teler";
    changelog = "https://github.com/kitabisa/teler/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "teler.app";
  };
}
