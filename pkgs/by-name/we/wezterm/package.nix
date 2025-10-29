{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  installShellFiles,
  libGL,
  libX11,
  libxcb,
  libxkbcommon,
  ncurses,
  nixosTests,
  openssl,
  perl,
  pkg-config,
  python3,
  runCommand,
  rustPlatform,
  vulkan-loader,
  wayland,
  wezterm,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilwm,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "0-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "wezterm";
    repo = "wezterm";
    rev = "db5d7437389eac5f63ad32e3b50d95b2b86065d1";
    fetchSubmodules = true;
    hash = "sha256-4OzgrXsSq68CP6iImhqW896X6ekv2seg4kaH3md6QLs=";
  };

  postPatch = ''
    echo ${version} > .tag

    # hash does not work well with NixOS
    substituteInPlace assets/shell-integration/wezterm.sh \
      --replace-fail 'hash wezterm 2>/dev/null' 'command type -P wezterm &>/dev/null' \
      --replace-fail 'hash base64 2>/dev/null' 'command type -P base64 &>/dev/null' \
      --replace-fail 'hash hostname 2>/dev/null' 'command type -P hostname &>/dev/null' \
      --replace-fail 'hash hostnamectl 2>/dev/null' 'command type -P hostnamectl &>/dev/null'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # many tests fail with: No such file or directory
    rm -r wezterm-ssh/tests
  '';

  # dep: syntax causes build failures in rare cases
  # https://github.com/rust-secure-code/cargo-auditable/issues/124
  # https://github.com/wezterm/wezterm/blob/main/nix/flake.nix#L134
  auditable = false;

  cargoHash = "sha256-QjYxDcWTbLTmtQEK6/ujwaDwdY+4C6EIOZ8I0hYIx00=";

  nativeBuildInputs = [
    installShellFiles
    ncurses # tic for terminfo
    pkg-config
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin perl;

  buildInputs = [
    fontconfig
    openssl
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libxcb
    libxkbcommon
    wayland
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm # contains xcb-ewmh among others
  ];

  buildFeatures = [ "distro-defaults" ];

  postInstall = ''
    mkdir -p $out/nix-support
    echo "${passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages

    install -Dm644 assets/icon/terminal.png $out/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
    install -Dm644 assets/wezterm.desktop $out/share/applications/org.wezfurlong.wezterm.desktop
    install -Dm644 assets/wezterm.appdata.xml $out/share/metainfo/org.wezfurlong.wezterm.appdata.xml

    install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
    installShellCompletion --cmd wezterm \
      --bash assets/shell-completion/bash \
      --fish assets/shell-completion/fish \
      --zsh assets/shell-completion/zsh

    install -Dm644 assets/wezterm-nautilus.py -t $out/share/nautilus-python/extensions
  '';

  preFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --add-needed "${libGL}/lib/libEGL.so.1" \
        --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
        $out/bin/wezterm-gui
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      OUT_APP="$out/Applications/WezTerm.app"
      cp -r assets/macos/WezTerm.app "$OUT_APP"
      rm $OUT_APP/*.dylib
      cp -r assets/shell-integration/* "$OUT_APP"
      # https://github.com/wezterm/wezterm/pull/6886
      # macOS will only recognize our application bundle
      # if the binaries are inside of it. Move them there
      # and create symbolic links for them in bin/.
      mv $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
      ln -s "$OUT_APP"/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$out/bin"
    '';

  passthru = {
    # the headless variant is useful when deploying wezterm's mux server on remote severs
    headless = import ./headless.nix {
      inherit
        openssl
        pkg-config
        rustPlatform
        wezterm
        ;
    };

    terminfo =
      runCommand "wezterm-terminfo"
        {
          nativeBuildInputs = [ ncurses ];
        }
        ''
          mkdir -p $out/share/terminfo $out/nix-support
          tic -x -o $out/share/terminfo ${src}/termwiz/data/wezterm.terminfo
        '';

    tests = {
      all-terminfo = nixosTests.allTerminfo;
      # the test is commented out in nixos/tests/terminal-emulators.nix
      #terminal-emulators = nixosTests.terminal-emulators.wezterm;
    };

    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezterm.org";
    license = licenses.mit;
    mainProgram = "wezterm";
    maintainers = with maintainers; [
      mimame
      SuperSandro2000
    ];
  };
}
