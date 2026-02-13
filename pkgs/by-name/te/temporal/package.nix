{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  testers,
  temporal,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "temporal";
  version = "1.29.3";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rifErftrYC2PnsJmorBE997OarqAg1xYsca1/EM4/KE=";
  };

  vendorHash = "sha256-CdzcOE/J0gqUbq7BXPpLFyNPNbFTziR5j9GPdYPzv50=";

  overrideModAttrs = old: {
    # netdb.go allows /etc/protocols and /etc/services to not exist and happily proceeds, but it panic()s if they exist but return permission denied.
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

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
    install -Dm755 "$GOPATH/bin/sql" -T $out/bin/temporal-sql-tool
    install -Dm755 "$GOPATH/bin/tdbg" -T $out/bin/tdbg

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.tests = {
    inherit (nixosTests) temporal;
    version = testers.testVersion {
      package = temporal;
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
