{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "yarr";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "nkanaev";
    repo = "yarr";
    rev = "v${version}";
    hash = "sha256-D/049qH6CFNL7MY5e54guA9i84pbAwGf2UPHnVQWCkU=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitHash=none"
  ];

  tags = [
    "sqlite_foreign_keys"
    "sqlite_json"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux nixosTests.yarr;
  };

  meta = {
    description = "Yet another rss reader";
    mainProgram = "yarr";
    homepage = "https://github.com/nkanaev/yarr";
    changelog = "https://github.com/nkanaev/yarr/blob/v${version}/doc/changelog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sikmir
      christoph-heiss
    ];
  };
}
