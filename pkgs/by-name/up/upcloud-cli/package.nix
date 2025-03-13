{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "upcloud-cli";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-cli";
    tag = "v${version}";
    hash = "sha256-bluq5rrfsd8xmKeqtNDqsZnhEAVZ4VqY/eYvOzXFKv4=";
  };

  vendorHash = "sha256-J0hLDQzyLYa8Nao0pR2eRkuJ5gP2VM9z+2n694YDYgI=";

  ldflags = [
    "-s -w -X github.com/UpCloudLtd/upcloud-cli/v3/internal/config.Version=${version}"
  ];

  subPackages = [
    "cmd/upctl"
    "internal/*"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/upctl";
  versionCheckProgramArg = [ "version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/UpCloudLtd/upcloud-cli/blob/refs/tags/v${version}/CHANGELOG.md";
    description = "Command-line tool for managing UpCloud services";
    homepage = "https://github.com/UpCloudLtd/upcloud-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lu1a ];
    mainProgram = "upctl";
  };
}
