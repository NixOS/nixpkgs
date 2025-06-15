{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:
let
  flags = import ./flags.nix;
in
buildGoModule rec {
  pname = "uds";
  version = "0.27.6";

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "uds-cli";
    tag = "v${version}";
    hash = "sha256-DVkm1INAiTKscjlJ9k2ysdIMbSY4qqxVDz4zZEk3BZ4=";
  };

  vendorHash = "sha256-EWDX01j7NFsX/oNlxy/JB2sm5C/NHzvRqYABXlkl3BQ=";

  # The e2e tests require a k8s cluster to run and there isn't a clean way to skip just them with checkFlags.
  doCheck = false;

  # this accepts a regex of test fn names to skip.
  # checkFlags =
  #   let
  #     # Skip e2e tests
  #     skippedTests = [
  #       ""
  #     ];
  #   in
  #   [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  env = {
    CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";
  };

  ldflags = flags.ldflags;

  meta = {
    description = "Secure runtime platform for National Security. https://uds.defenseunicorns.com/";
    homepage = "https://uds.defenseunicorns.com/";
    mainProgram = "uds";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ realnedsanders ];
  };
}
