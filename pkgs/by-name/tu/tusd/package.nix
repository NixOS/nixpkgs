{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "tusd";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "tus";
    repo = "tusd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xZGGvXLluugPEq6zW25yMG5K+IPKw6PrGOM/GBlox1k=";
  };

  vendorHash = "sha256-V2EPvrTzs31tagVU3kl+8Fcn0xvLBsUuMKEYwPGJHy0=";

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
    maintainers = with lib.maintainers; [
      nh2
      kalbasit
      kvz
      Acconut
    ];
  };
})
