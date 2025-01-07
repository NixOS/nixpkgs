{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  testers,
  webmesh,
}:

buildGoModule rec {
  pname = "webmesh";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "webmeshproj";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Inh7j01/xBJgGYmX1tGBRNYjn1N4AO2sywBwZ8yXlsY=";
  };

  vendorHash = "sha256-xoc7NSdg5bn3aXgcrolJwv8jyrv2HEXFmiCtRXBVwVg=";

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/webmesh-node"
    "cmd/webmeshd"
    "cmd/wmctl"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X github.com/webmeshproj/webmesh/pkg/version.Version=${version}"
    "-X github.com/webmeshproj/webmesh/pkg/version.GitCommit=v${version}"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      webmesh-version = testers.testVersion {
        package = webmesh;
      };
    };
  };

  meta = with lib; {
    description = "Simple, distributed, zero-configuration WireGuard mesh provider";
    mainProgram = "webmesh-node";
    homepage = "https://webmeshproj.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
