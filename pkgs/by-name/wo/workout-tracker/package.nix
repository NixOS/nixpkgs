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
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    tag = "v${version}";
    hash = "sha256-sISgUNrs3mRGyAG9i/BFV6DAUM3v+07FDWTLVxmTDnU=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-gY5xkP/MxVLiUz1O69uOw1VpqnKUKXonecgjadKHsxQ=";
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

  vendorHash = "sha256-Val73lO3Ris3ufJUh3XYLo0p8gWHsHdDSlJyHRVHJ/4=";

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
      bhankas
      sikmir
    ];
  };
}
