{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tork";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "melqtx";
    repo = "tork";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l8U7h8X9NhMIdnNYXgJIfd/b03GZzbvIGLo0mrcJucU=";
  };

  vendorHash = "sha256-gQLqY3trLGP/2teQlR+px+/iIKyzEs90pi52ufRXufc=";

  subPackages = [ "cmd/tork" ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    # Tests fail with "mkdir /homeless-shelter: read-only file system" without a writable HOME.
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal torrent search and download client";
    homepage = "https://github.com/melqtx/tork";
    changelog = "https://github.com/melqtx/tork/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ melqtx ];
    mainProgram = "tork";
    platforms = lib.platforms.unix;
  };
})
