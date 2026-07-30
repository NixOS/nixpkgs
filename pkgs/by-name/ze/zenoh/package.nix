{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  testers,
  zenoh,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh";
  version = "1.9.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh";
    rev = finalAttrs.version;
    hash = "sha256-sFHUphFu5a+buSa3GQvSmGo8SFtn3V5ZqTOnWMPlvs8=";
  };

  cargoHash = "sha256-1PjtZ5/bAnLlMbkcKAA6DCKDafItGiATjct5Pv8muas=";

  cargoBuildFlags = [
    "--workspace"
    "--bins"
    "--lib"
    "--examples"
    "--exclude"
    "zenoh-backend-example"
    "--exclude"
    "zenoh-plugin-example"
    "--exclude"
    "zenoh-ext-examples"
  ];

  doCheck = false;

  preInstall = ''
    cp -r $releaseDir/examples/* $tmpDir/
    bins=$(find $tmpDir \
      -maxdepth 1 \
      -type f \
      -executable \
      -regextype posix-extended \
      ! -regex ".*\.(so\.[0-9.]+|so|a|d|dylib)|.*-[0-9a-f]{16,}")
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = zenoh;
      version = "v" + finalAttrs.version;
    };
    zenohd = nixosTests.zenohd;
  };

  meta = {
    description = "Communication protocol that combines pub/sub with key value storage and computation";
    longDescription = "Zenoh unifies data in motion, data in-use, data at rest and computations. It carefully blends traditional pub/sub with geo-distributed storages, queries and computations, while retaining a level of time and space efficiency that is well beyond any of the mainstream stacks";
    homepage = "https://zenoh.io";
    changelog = "https://github.com/eclipse-zenoh/zenoh/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "zenohd";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
