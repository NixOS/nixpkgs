{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  ...
}:
let
  pname = "workout-tracker";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    tag = "v${version}";
    hash = "sha256-DJOYjKujb6mmqJcYhzPLv1uYgAIWW4hdH/gILlqkJXQ=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-/OBIRiLwUtXVmmg44FYqV0BptxQTg8bDuNMTj8IYwG0=";
    dontNpmBuild = true;
    makeCacheWritable = true;
    postPatch = ''
      rm Makefile
    '';
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = null;

  postPatch = ''
    ln -s ${assets}/node_modules ./node_modules
    make build-dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.buildTime=1970-01-01T00:00:00Z"
    "-X main.gitCommit=v${version}"
    "-X main.gitRef=v${version}"
    "-X main.gitRefName=v${version}"
  ];

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
