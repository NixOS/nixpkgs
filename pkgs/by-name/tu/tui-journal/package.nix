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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-crrh7lV5ZMKaxsrFmhXsUgBMbN5nmbf8wQ6croTqUKI=";
  };

  cargoHash = "sha256-PmQDLGOXvI0OJ+gMsYa/XLc0WgSH6++23X/b1+iU3JQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Your journal app if you live in a terminal";
    homepage = "https://github.com/AmmarAbouZor/tui-journal";
    changelog = "https://github.com/AmmarAbouZor/tui-journal/blob/${finalAttrs.src.rev}/CHANGELOG.ron";
    license = lib.licenses.mit;
    mainProgram = "tjournal";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
