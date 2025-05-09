{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  util-linux,
  libgbm,
  pipewire,
  gst_all_1,
  mesa,
  pkg-config,
  libglvnd,
  libxkbcommon,
  pipewire,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-7yfrjKHuYOWPMMkHdGZ+g0hynh2TtSf4h8zW13tTus4=";
  };

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-04-08";
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fOaLeWtrjgBDSShC5OmBZKODNQn4bp/+iPZX5ZMQFqk=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    libglvnd
    libxkbcommon
    mesa
    pipewire
    wayland
  ];
  checkInputs = [ gst_all_1.gstreamer ];

  postPatch = ''
    # While the `kate-hazen-COSMIC-desktop-wallpaper.png` image is present
    # in the `pop-wallpapers` package, we're using the Orion Nebula image
    # from NASA available in the `cosmic-wallpapers` package. Mainly because
    # the previous image was used in the GNOME shell extension and the
    # Orion Nebula image is widely used in the Rust-based COSMIC DE's
    # marketing materials. Another reason to use the Orion Nebula image
    # is that it's actually the default wallpaper as configured by the
    # `cosmic-bg` package's configuration in upstream [1] [2].
    #
    # [1]: https://github.com/pop-os/cosmic-bg/blob/epoch-1.0.0-alpha.6/config/src/lib.rs#L142
    # [2]: https://github.com/pop-os/cosmic-bg/blob/epoch-1.0.0-alpha.6/data/v1/all#L3
    substituteInPlace src/screenshot.rs src/widget/screenshot.rs \
      --replace-fail '/usr/share/backgrounds/pop/kate-hazen-COSMIC-desktop-wallpaper.png' '${cosmic-wallpapers}/share/backgrounds/cosmic/orion_nebula_nasa_heic0601a.jpg'

    # Also modifies the functionality by replacing 'false' with 'true' to enable the portal to start properly.
    substituteInPlace data/org.freedesktop.impl.portal.desktop.cosmic.service \
      --replace-fail 'Exec=/bin/false' 'Exec=${lib.getExe' coreutils "true"}'
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
