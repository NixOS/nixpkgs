{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "xplr";
    rev = "v${version}";
    hash = "sha256-78MHWdvWxXGcptMW3AUTYrpfdAai59x1KnW4uMaUZC8=";
  };

  cargoHash = "sha256-qC9KutkGLUuG7xQeO/Vg3oRqh8hCQuHisJA5diYizAg=";

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

  meta = with lib; {
    description = "Hackable, minimal, fast TUI file explorer";
    mainProgram = "xplr";
    homepage = "https://xplr.dev";
    changelog = "https://github.com/sayanarijit/xplr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      sayanarijit
      suryasr007
      pyrox0
      mimame
      figsoda
    ];
  };
}
