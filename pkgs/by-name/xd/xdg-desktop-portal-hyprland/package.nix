{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wayland-scanner,
  makeWrapper,
  wrapQtAppsHook,
  nix-update-script,
  hyprland-protocols,
  hyprlang,
  libdrm,
  mesa,
  pipewire,
  qtbase,
  qttools,
  qtwayland,
  sdbus-cpp,
  systemd,
  wayland,
  wayland-protocols,
  hyprland,
  hyprpicker,
  slurp,
}:
stdenv.mkDerivation (self: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    rev = "v${self.version}";
    hash = "sha256-cyyxu/oj4QEFp3CVx2WeXa9T4OAUyynuBJHGkBZSxJI=";
  };

  patches = [
    # TODO: remove on next upgrade
    (fetchpatch {
      name = "fix-compilation-pipewire-1.2.0.patch";
      url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/c5b30938710d6c599f3f5cd99a3ffac35381fb0f.patch";
      hash = "sha256-f9OgW9tLuGuHXYH6bR1Y+CEuBPHOhRiHfEPebJzlwK8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    libdrm
    mesa
    pipewire
    qtbase
    qttools
    qtwayland
    sdbus-cpp
    systemd
    wayland
    wayland-protocols
  ];

  dontWrapQtApps = true;

  postInstall = ''
    wrapProgramShell $out/bin/hyprland-share-picker \
      "''${qtWrapperArgs[@]}" \
      --prefix PATH ":" ${
        lib.makeBinPath [
          slurp
          hyprland
        ]
      }

    wrapProgramShell $out/libexec/xdg-desktop-portal-hyprland \
      --prefix PATH ":" ${
        lib.makeBinPath [
          (placeholder "out")
          hyprpicker
        ]
      }
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    description = "xdg-desktop-portal backend for Hyprland";
    mainProgram = "hyprland-share-picker";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
  };
})
