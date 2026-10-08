{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  installShellFiles,
  ncurses,
  wayland,
  libxkbcommon,
  fontconfig,
  vulkan-loader,
  xdg-utils,
  libnotify,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tron-terminal";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "skyline69";
    repo = "tron-terminal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VdgW5o87oZt7OGh64nLzXW45zf5XFh0U1gflxVSQKvQ=";
  };

  cargoHash = "sha256-ZJXAgYgOjbgngDNdwDDXDU+ZmYPaMrAaRJainxnXuaM=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];
  buildInputs = [ fontconfig ];
  nativeCheckInputs = [ ncurses ];
  cargoTestFlags = [
    "-p"
    "tron"
    "-p"
    "tron-config"
  ];

  postPatch =
    let
      # Only embed shaders with an identified free license or permission grant.
      # Other upstream shaders are CC BY-NC-SA or have no stated license.
      # In particular, glow-rgbsplit-twitchy derives from unlicensed code at
      # https://github.com/kalgynirae/dotfiles/blob/main/ghostty/glow.glsl
      freeShaders = [
        "afterglow.wgsl"
        "bloom.wgsl"
        "crt-lottes.wgsl"
        "crt.wgsl"
        "cursor-glow.wgsl"
        "cursor-sweep.wgsl"
        "cursor-tail.wgsl"
        "cursor-trail.wgsl"
        "cursor-warp.wgsl"
        "inside-the-matrix.wgsl"
        "rectangle-boom-cursor.wgsl"
        "ripple-cursor.wgsl"
        "ripple-rectangle-cursor.wgsl"
        "sonic-boom-cursor.wgsl"
        "sparks-from-fire.wgsl"
      ];
    in
    ''
      for shader in ${lib.escapeShellArgs freeShaders}; do
        test -f "examples/shaders/$shader"
      done
      for shader in examples/shaders/*.wgsl; do
        case " ${lib.concatStringsSep " " freeShaders} " in
          *" $(basename "$shader") "*) ;;
          *) rm "$shader" ;;
        esac
      done
    '';

  postInstall = ''
    install -Dm644 dist/dev.tron.Terminal.desktop $out/share/applications/dev.tron.Terminal.desktop
    install -Dm644 dist/dev.tron.Terminal.svg $out/share/icons/hicolor/scalable/apps/dev.tron.Terminal.svg
    install -Dm644 dist/dev.tron.Terminal.png $out/share/icons/hicolor/128x128/apps/dev.tron.Terminal.png
    install -Dm644 dist/dev.tron.Terminal.metainfo.xml $out/share/metainfo/dev.tron.Terminal.metainfo.xml
    installShellCompletion --cmd tron \
      --bash <($out/bin/tron completions bash) \
      --fish <($out/bin/tron completions fish) \
      --zsh <($out/bin/tron completions zsh)
    wrapProgram $out/bin/tron \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          vulkan-loader
        ]
      }" \
      --prefix PATH : "${
        lib.makeBinPath [
          ncurses
          xdg-utils
          libnotify
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast GPU-accelerated terminal emulator";
    homepage = "https://github.com/skyline69/tron-terminal";
    changelog = "https://github.com/skyline69/tron-terminal/releases/tag/v${finalAttrs.version}";
    # Third-party ports retain their original licenses; see
    # https://github.com/skyline69/tron-terminal/blob/v0.4.4/examples/shaders/README.md
    license = with lib.licenses; [
      # Tron, themes, and MIT cursor-shader ports.
      mit
      asl20
      # crt-lottes (the notice in Qwerasd's gist applies to crt.glsl, not bloom.glsl).
      unlicense
      # sparks-from-fire.
      cc-by-30
      # inside-the-matrix: "Feel free to do anything you want with this code."
      free
    ];
    maintainers = with lib.maintainers; [ body20002 ];
    mainProgram = "tron";
    platforms = lib.platforms.linux;
  };
})
