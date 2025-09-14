{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "ugm";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ariasmn";
    repo = "ugm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AkiAF9zLgyzXRC6efjQ+eeAL3mOSQM94B8nr09pcY5M=";
  };

  vendorHash = "sha256-W9v52cxhXdNyW5RGk+SoA1u7Yid+63YYdd9YaGKEWDs=";

  nativeBuildInputs = [ makeWrapper ];

  # Fix unaligned table when running this program under a CJK environment
  postFixup = ''
    wrapProgram $out/bin/ugm \
        --set RUNEWIDTH_EASTASIAN 0
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal based UNIX user and group browser";
    homepage = "https://github.com/ariasmn/ugm";
    changelog = "https://github.com/ariasmn/ugm/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "ugm";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
})
