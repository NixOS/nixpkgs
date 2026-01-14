{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:
let
  pname = "workout-tracker";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    tag = "v${version}";
    hash = "sha256-S7rKa79w5Lqv8QBKNc8Zp35GOOBN4JnoNE7FNWsCzoY=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-vSFwCB5qbiHLiK0ns6YUj8yr3FjeNCqT8yvLRQzZycI=";
    makeCacheWritable = true;
    postPatch = ''
      cd frontend
    '';
    installPhase = ''
      runHook preInstall
      cp -r ../assets "$out"
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = null;

  postPatch = ''
    rm -r assets
    ln -s ${assets} ./assets
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.buildTime=1970-01-01T00:00:00Z"
    "-X main.gitCommit=v${version}"
    "-X main.gitRef=v${version}"
    "-X main.gitRefName=v${version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    inherit (nixosTests) workout-tracker;
  };

  meta = {
    changelog = "https://github.com/jovandeginste/workout-tracker/releases/tag/v${version}";
    description = "Workout tracking web application for personal use";
    homepage = "https://github.com/jovandeginste/workout-tracker";
    license = lib.licenses.mit;
    mainProgram = "workout-tracker";
    maintainers = with lib.maintainers; [
      bhankas
      sikmir
    ];
  };
}
