{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xplr";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "xplr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lLuB0QOhMv4GLZT7lh7cUkVmWm0iwJ1WTf9aW+D69aE=";
  };

  cargoHash = "sha256-NWdpPTpnWwiCqlIqkPrIMSU4Xi80rd6FcP/I1L6QYBs=";

  # fixes `thread 'main' panicked at 'cannot find strip'` on x86_64-darwin
  env = lib.optionalAttrs (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin) {
    TARGET_STRIP = "${stdenv.cc.targetPrefix}strip";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp assets/desktop/xplr.desktop $out/share/applications

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp assets/icon/xplr.svg $out/share/icons/hicolor/scalable/apps

    for size in 16 32 64 128; do
      icon_dir=$out/share/icons/hicolor/''${size}x$size/apps
      mkdir -p $icon_dir
      cp assets/icon/xplr$size.png $icon_dir/xplr.png
    done
  '';

  meta = {
    description = "Hackable, minimal, fast TUI file explorer";
    mainProgram = "xplr";
    homepage = "https://xplr.dev";
    changelog = "https://github.com/sayanarijit/xplr/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sayanarijit
      suryasr007
      mimame
    ];
  };
})
