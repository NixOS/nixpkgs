{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminalmap";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "psmux";
    repo = "TerminalMap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6L3K5meR5pR8/U7QbW+qMaO2m+GNVB5Gny5gFCGE+hE=";
  };

  cargoHash = "sha256-VNvSjxCRO93beSY5DD1Vi/Wz87uYlkyyNeYVf8q860U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  __structuredAttrs = true;

  meta = {
    description = "Tool to render real world maps in your terminal";
    homepage = "https://github.com/psmux/TerminalMap";
    changelog = "https://github.com/psmux/TerminalMap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "terminalmap";
  };
})
