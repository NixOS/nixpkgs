{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  testers,
  temporal,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "temporal";
  version = "1.31.2";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NuvgeG1a7octJ2HD0EGQIdU8CtZsNRf4KX/F17S/uOQ=";
  };

  vendorHash = "sha256-KZKlARki/AXGhfsQsOixHjx+t1H9htd9oBx3wsiebY0=";

  excludedPackages = [ "./build" ];

  env.CGO_ENABLED = 0;

  tags = [ "test_dep" ];
  ldflags = [
    "-s"
    "-w"
  ];

  # There too many integration tests.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ./schema $out/share/

    install -Dm755 "$GOPATH/bin/server" -T $out/bin/temporal-server
    install -Dm755 "$GOPATH/bin/cassandra" -T $out/bin/temporal-cassandra-tool
    install -Dm755 "$GOPATH/bin/elasticsearch" -T $out/bin/temporal-elasticsearch-tool
    install -Dm755 "$GOPATH/bin/sql" -T $out/bin/temporal-sql-tool
    install -Dm755 "$GOPATH/bin/tdbg" -T $out/bin/tdbg

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests) temporal;
      version = testers.testVersion {
        package = temporal;
      };
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Microservice orchestration platform which enables developers to build scalable applications without sacrificing productivity or reliability";
    homepage = "https://temporal.io";
    changelog = "https://github.com/temporalio/temporal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpds ];
    mainProgram = "temporal-server";
  };
})
