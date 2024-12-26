{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  zenoh,
}:
rustPlatform.buildRustPackage rec {
  pname = "zenoh";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh";
    rev = version;
    hash = "sha256-Ydmd3eCXn+svMak1I5LU4rJNhzEEc2MiG5MoSMNOJ00=";
  };

  cargoHash = "sha256-AjMgnZ+GJPGMQsyeOQGyXpVrdw2zb7B9/KXWKlvKT1Q=";

  cargoBuildFlags = [
    "--workspace"
    # exclude examples
    "--exclude"
    "examples"
    "--exclude"
    "zenoh-backend-example"
    "--exclude"
    "zenoh-plugin-example"
    "--exclude"
    "zenoh-ext-examples"
  ];

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = zenoh;
    version = "v" + version;
  };

  meta = {
    description = "Communication protocol that combines pub/sub with key value storage and computation";
    longDescription = "Zenoh unifies data in motion, data in-use, data at rest and computations. It carefully blends traditional pub/sub with geo-distributed storages, queries and computations, while retaining a level of time and space efficiency that is well beyond any of the mainstream stacks";
    homepage = "https://zenoh.io";
    changelog = "https://github.com/eclipse-zenoh/zenoh/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "zenohd";
    platforms = lib.platforms.linux;
  };
}
