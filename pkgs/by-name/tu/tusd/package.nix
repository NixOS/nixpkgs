{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "tusd";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "tus";
    repo = "tusd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fE8r9KqHNgP51F+RMUO0k5P5jSXnd3eVRYGPLa+IvJM=";
  };

  vendorHash = "sha256-xH1y6IaEz2Np0d27Yu92h9Y/IsUroVwLky/wWf0QKvY=";

  ldflags = [
    "-X github.com/tus/tusd/v2/cmd/tusd/cli.VersionName=v${finalAttrs.version}"
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
    mainProgram = "tusd";
    maintainers = with lib.maintainers; [
      nh2
      kalbasit
      kvz
      Acconut
    ];
  };
})
