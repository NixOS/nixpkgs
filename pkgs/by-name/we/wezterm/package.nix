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
  unstableGitUpdater,
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
  version = "0-unstable-2025-01-03";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "wezterm";
    rev = "8e9cf912e66f704f300fac6107206a75036de1e7";
    fetchSubmodules = true;
    hash = "sha256-JkAovAeoVrH2QlHzzcciraebfsSQPBQPsA3fUKEjRm8=";
  };

  postPatch = ''
    echo ${version} > .tag

    # tests are failing with: Unable to exchange encryption keys
    rm -r wezterm-ssh/tests

    # hash does not work well with NixOS
    substituteInPlace assets/shell-integration/wezterm.sh \
      --replace-fail 'hash wezterm 2>/dev/null' 'command type -P wezterm &>/dev/null' \
      --replace-fail 'hash base64 2>/dev/null' 'command type -P base64 &>/dev/null' \
      --replace-fail 'hash hostname 2>/dev/null' 'command type -P hostname &>/dev/null' \
      --replace-fail 'hash hostnamectl 2>/dev/null' 'command type -P hostnamectl &>/dev/null'
  '';

  cargoHash = "sha256-UagPKPH/PRXk3EFe+rDbkSTSnHdi/Apz0Qek8YlNMxo=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    installShellFiles
    ncurses # tic for terminfo
    pkg-config
    python3
  ] ++ lib.optional stdenv.hostPlatform.isDarwin perl;

  buildInputs =
    [
      fontconfig
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libxcb
      libxkbcommon
      openssl
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
      ln -s $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
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

    # upstream tags are composed with timestamp+commit, e.g.:
    # 20240203-110809-5046fc22
    # doesn't make much sense if we are following unstable
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = with lib; {
    description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    mainProgram = "wezterm";
    maintainers = with maintainers; [
      mimame
      SuperSandro2000
      thiagokokada
    ];
  };
}
