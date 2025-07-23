{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2025-07-17";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "4fd6eb1694aeac7a1ea4d6754c9d888501911cd8";
    hash = "sha256-l4MH6wLDqTP+z8dVxDjyzDlX7KTZSDOptp/EVqxXUxc=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-9gZ1h/rsJ5DEcU8CJGKszE98GzZqfs2ELp1lbXsliYk=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/tsgo"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    version="$("$out/bin/tsgo" --version)"
    [[ "$version" == *"7.0.0"* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Go implementation of TypeScript";
    homepage = "https://github.com/microsoft/typescript-go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsgo";
  };
}
