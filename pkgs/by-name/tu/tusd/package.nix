{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "tusd";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "tus";
    repo = "tusd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rG86IibKEjJ4/JNEBpU9APIrS57b4XL/9/HQIRWb5PM=";
  };

  vendorHash = "sha256-5Sh4u+tW9TPJUNQiBWmG1fQUYVtO+plT4ZZ49iQeXSU=";

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
