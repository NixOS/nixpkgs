{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zyouz";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "YutaUra";
    repo = "zyouz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m8KTillhvWqIAACKL9k8iYVLyp9iXu5pl/AaCFvfuu8=";
  };

  nativeBuildInputs = [ zig ];

  # Zig tests require a TTY, which is unavailable in the Nix sandbox
  dontUseZigCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal multiplexer driven by a static config file";
    homepage = "https://github.com/YutaUra/zyouz";
    changelog = "https://github.com/YutaUra/zyouz/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yutaura ];
    mainProgram = "zyouz";
    platforms = lib.platforms.unix;
  };
})
