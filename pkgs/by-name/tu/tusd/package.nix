{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "tusd";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "tus";
    repo = "tusd";
    tag = "v${version}";
    hash = "sha256-OzXBeLDjaJk4NVgsauR/NUATh7qHbuEfWNdhytZmd0A=";
  };

  vendorHash = "sha256-YununGyB72zE0tmqO3BREJeMTjCuy/1fhPHC5r8OLjg=";

  ldflags = [
    "-X github.com/tus/tusd/v2/cmd/tusd/cli.VersionName=v${version}"
  ];

  # Tests need the path to the binary:
  # https://github.com/tus/tusd/blob/0e52ad650abed02ec961353bb0c3c8bc36650d2c/internal/e2e/e2e_test.go#L37
  preCheck = ''
    export TUSD_BINARY=$PWD/../go/bin/tusd
  '';

  passthru.tests.tusd = nixosTests.tusd;

  meta = {
    description = "Reference server implementation in Go of tus: the open protocol for resumable file uploads";
    license = lib.licenses.mit;
    homepage = "https://tus.io/";
    maintainers = with lib.maintainers; [
      nh2
      kalbasit
      kvz
      Acconut
    ];
  };
}
