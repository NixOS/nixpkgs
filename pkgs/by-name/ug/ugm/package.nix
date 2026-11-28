{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ugm";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "ariasmn";
    repo = "ugm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rsUK52mFT2wsN8B+Y96QOepoxI+ocxUgzMH0/zmNXn8=";
  };

  vendorHash = "sha256-npVr9Gf+MwMpURyWqhzbpqJYNg+82KGPGfN5uSSdK8A=";

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
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
