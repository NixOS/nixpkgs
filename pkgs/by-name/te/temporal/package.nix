{ lib, fetchFromGitHub, buildGoModule, testers, temporal }:

buildGoModule rec {
  pname = "temporal";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporal";
    rev = "v${version}";
    hash = "sha256-hQs2rSTbNqknQ/N0mZ8BxeKQn2Pm9Yt/5eKGB2Kc+ME=";
  };

  vendorHash = "sha256-kasKs692fHojyCLsSdho5LWej11Asu8JJb61rbg1k2k=";

  excludedPackages = [ "./build" ];

  env.CGO_ENABLED = 0;

  tags = [ "test_dep" ];
  ldflags = [ "-s" "-w" ];

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

  passthru.tests.version = testers.testVersion {
    package = temporal;
  };

  meta = with lib; {
    description = "Microservice orchestration platform which enables developers to build scalable applications without sacrificing productivity or reliability";
    homepage = "https://temporal.io";
    changelog = "https://github.com/temporalio/temporal/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpds ];
    mainProgram = "temporal-server";
  };
}
