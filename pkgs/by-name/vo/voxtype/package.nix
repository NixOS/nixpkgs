{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  cmake,
  git,
  alsa-lib,
  libclang,
  makeWrapper,
  wtype,
  wl-clipboard,
  ydotool,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voxtype";
  version = "0.4.14";

  src = fetchFromGitHub {
    owner = "peteonrails";
    repo = "voxtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8H3tohZcFbech1VOg3EP9iXDLh3aZR2mkLdVsPLYu7A=";
  };

  cargoHash = "sha256-9KImGiaVzBPp6kVVCwbdoK/yULS17+eNq6+tl7i1vBQ=";

  nativeBuildInputs = [
    pkg-config
    cmake
    git
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
  ];

  env = {
    LIBCLANG_PATH = "${libclang.lib}/lib";
    VOXTYPE_GEN_MANPAGES = "1";
  };

  postInstall = ''
    wrapProgram $out/bin/voxtype \
      --prefix PATH : ${
        lib.makeBinPath [
          wtype
          wl-clipboard
          ydotool
        ]
      }

    mandir=$(find target -path '*/build/voxtype-*/out/man' -type d | head -1)
    if [ -n "$mandir" ] && [ -d "$mandir" ]; then
      install -Dm644 "$mandir"/*.1 -t $out/share/man/man1/
    fi
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Push-to-talk voice-to-text for Wayland and X11 using local AI models via whisper.cpp";
    longDescription = ''
      Voxtype is a push-to-talk voice-to-text application specifically designed
      for Linux desktops. It uses whisper.cpp for offline speech recognition
      and supports both Wayland and X11 desktops including GNOME, KDE, Sway,
      Hyprland, and River.
    '';
    homepage = "https://github.com/peteonrails/voxtype";
    changelog = "https://github.com/peteonrails/voxtype/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pblgomez ];
    platforms = lib.platforms.linux;
    mainProgram = "voxtype";
  };
})
