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
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WcWHWJUhv5tCyac1Gdw+4ijIWYKgCWmUbK1tH/QCEMs=";
  };

  cargoHash = "sha256-MVY9xanWaEzvwwlhM/EJk7qGkmGIjzxh4WTuyv4mQGo=";

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
