{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  testers,
  temporal,
}:

buildGoModule rec {
  pname = "temporal";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    rev = "v${version}";
    hash = "sha256-oxn/78nQCvlEkSqabVV47siWSSnz32tpDOweqScPYvY=";
  };

  vendorHash = "sha256-HW2j8swbaWwU1i3udqlT8VyFreML6ZH14zWxF8L5NTQ=";

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

  passthru.tests = {
    inherit (nixosTests) temporal;
    version = testers.testVersion {
      package = temporal;
    };
  };

  meta = {
    description = "Microservice orchestration platform which enables developers to build scalable applications without sacrificing productivity or reliability";
    homepage = "https://temporal.io";
    changelog = "https://github.com/temporalio/temporal/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpds ];
    mainProgram = "temporal-server";
  };
}
