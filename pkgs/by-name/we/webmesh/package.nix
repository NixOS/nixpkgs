{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  testers,
  webmesh,
}:

buildGoModule (finalAttrs: {
  pname = "webmesh";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "webmeshproj";
    repo = "webmesh";
    rev = "v${finalAttrs.version}";
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
    "-X github.com/webmeshproj/webmesh/pkg/version.Version=${finalAttrs.version}"
    "-X github.com/webmeshproj/webmesh/pkg/version.GitCommit=v${finalAttrs.version}"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      webmesh-version = testers.testVersion {
        package = webmesh;
      };
    };
  };

  meta = {
    description = "Simple, distributed, zero-configuration WireGuard mesh provider";
    mainProgram = "webmesh-node";
    homepage = "https://webmeshproj.github.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
  };
})
