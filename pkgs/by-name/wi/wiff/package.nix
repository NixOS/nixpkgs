{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wiff";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wez";
    repo = "wiff";
    rev = "6e76b0afad17987ef4aafc0c375b69cf83a5f51d";
    hash = "sha256-PdyixXuob6RoiAUTHO+FJ4GJj6njuZqMTuAwOmsnh4Q=";
  };

  cargoHash = "sha256-m0gCmZ8ozVjQkuffTaMHmOcaoJAx0aJW5cgKTTi+U6g=";

  nativeCheckInputs = [
    git
  ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  meta = {
    description = "Terminal-centric diff and code-review utility";
    longDescription = ''
      wiff captures a diff and lets you browse and annotate it with syntax
      highlighting from the comfort of your terminal. Reviews are persisted as
      local sessions that both a human (through the TUI) and an agent (through
      the CLI and a skill) can read and write at the same time. It works
      entirely offline on your local working tree, index or history, and can
      also mirror a GitHub pull request into a local session and publish the
      review back to the forge.
    '';
    homepage = "https://github.com/wez/wiff";
    changelog = "https://github.com/wez/wiff/commits/main";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philocalyst
    ];
    mainProgram = "wiff";
  };
})
