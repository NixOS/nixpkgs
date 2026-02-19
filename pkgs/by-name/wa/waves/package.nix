{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  alsa-lib,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "waves";
  version = "0.1.41";

  src = fetchFromGitHub {
    owner = "llehouerou";
    repo = "waves";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F3ZJSaL8e8TO2J0k3p33zrqMwurw6xIA+AuloNp3Zw0=";
  };

  vendorHash = "sha256-jUwA7KOHceuwSUMDzex8MHCBYvMPRkfkyk5THvXsF+M=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-driven terminal music player with Soulseek integration, Last.fm scrobbling, and radio mode";
    homepage = "https://github.com/llehouerou/waves";
    changelog = "https://github.com/llehouerou/waves/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ llehouerou ];
    mainProgram = "waves";
  };
})
