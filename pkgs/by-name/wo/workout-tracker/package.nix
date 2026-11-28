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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    tag = "v${version}";
    hash = "sha256-GGaoV9dk15OD2pKv5hcNe7vB/hktx3fsK9VIVeQylnY=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-zpqxhDBdLOdTk0uwJNpDGd/bWQE0CMiTQO9XkpkGZTE=";
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

  vendorHash = "sha256-EYrAv3cd4WiA1k6s+C1I4yiv3IEfawHM5gBSNc7dFHo=";

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

  passthru = {
    inherit assets;
    updateScript = nix-update-script { extraArgs = [ "--subpackage=assets" ]; };
  };

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
      sikmir
    ];
  };
}
