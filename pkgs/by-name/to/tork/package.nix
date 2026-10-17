{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tork";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "melqtx";
    repo = "tork";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z6F9r/Hfi4zsi0VH9Z7dEn1nA8B+aVKYqiq72J4m5BU=";
  };

  vendorHash = "sha256-Vk3lmPUDvuhOzha8GlH0anRLgVhhyFjz9y328T2gycs=";

  subPackages = [ "cmd/tork" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # Nix builds with HOME=/homeless-shelter. A few integration-style tests create
  # an isolated tork config, which derives its default download directory from
  # HOME, so give the check phase a writable private home instead.
  preCheck = ''
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal torrent search and download client";
    homepage = "https://github.com/melqtx/tork";
    changelog = "https://github.com/melqtx/tork/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ melqtx ];
    mainProgram = "tork";
    platforms = lib.platforms.unix;
  };
})
