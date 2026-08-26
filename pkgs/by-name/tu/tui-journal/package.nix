{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tui-journal";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ahjCfSodq4foBV3aBbU0FsSUrEo3wgvFYSBr/OClmpc=";
  };

  cargoHash = "sha256-hbRSQ9iVmp0oKEK53y4IuU34WNgq+pRefNxFbP1DPVQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/AmmarAbouZor/tui-journal/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Your journal app if you live in a terminal";
    homepage = "https://github.com/AmmarAbouZor/tui-journal";
    license = lib.licenses.mit;
    mainProgram = "tjournal";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
