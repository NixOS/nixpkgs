{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "trzsz-ssh";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-ssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-96xISHU0/C473Ohi3obsO1ihkxa0Q7Z39JIKzt5R7iM=";
  };

  vendorHash = "sha256-t/uJ+YyemTsDbuO+7VlOjFY8DvizkSZCE6uloA4mNqY=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Failing test - Expected output is a table in plain text, but got ANSI color codes for the table's border
        # Reported upstream: https://github.com/trzsz/trzsz-ssh/issues/277
        "TestTableExample"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH client designed as a drop-in replacement for the openssh client";
    homepage = "https://github.com/trzsz/trzsz-ssh";
    changelog = "https://github.com/trzsz/trzsz-ssh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "trzsz-ssh";
  };
})
