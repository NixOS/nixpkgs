{
  lib,
  buildGoModule,
  buildNpmPackage,
  coreutils,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  nodejs_26,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "unpackerr";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Unpackerr";
    repo = "unpackerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iKEmEm6qnNQVEUXz0jppeZCgss5HhGzlGkpWtkFPIZM=";
  };

  vendorHash = "sha256-fE0PrtbJbvUtoz4BWesiCh7Wx89qDLx8aMIY1TiSZfE=";

  postConfigure = ''
    cp -rT ${finalAttrs.passthru.frontend} frontend/dist
  '';

  excludedPackages = [ "init/config" ];

  ldflags = [
    "-s"
    "'-X=golift.io/version.Branch=${finalAttrs.version} [nixpkgs]'"
    "-X=golift.io/version.BuildUser=nixpkgs"
    "-X=golift.io/version.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    substituteInPlace pkg/hooks/fire_test.go pkg/unpackerr/configtest_test.go \
      --replace-fail /bin/echo ${lib.getExe' coreutils "echo"}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    frontend = buildNpmPackage {
      pname = "${finalAttrs.pname}-frontend";
      inherit (finalAttrs) version src;
      __structuredAttrs = true;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      npmDepsHash = "sha256-2mgP/b1A1aGUn2T1lmno0JxL3D6c9VBnISJcsoRDZA0=";
      nodejs = nodejs_26;
      doCheck = true;
      checkPhase = ''
        runHook preCheck
        npm test
        runHook postCheck
      '';
      installPhase = ''
        runHook preInstall
        cp -r dist "$out"
        runHook postInstall
      '';
    };

    tests = { inherit (nixosTests) unpackerr; };

    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } { subpackage = "frontend"; };
    };
  };

  meta = {
    description = "Extracts downloads so Radarr, Sonarr, Lidarr or Readarr may import them";
    homepage = "https://unpackerr.zip";
    changelog = "https://github.com/Unpackerr/unpackerr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ connor-grady ];
    mainProgram = "unpackerr";
  };
})
