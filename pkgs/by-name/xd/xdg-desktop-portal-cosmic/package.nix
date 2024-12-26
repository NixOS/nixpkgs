{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gst_all_1,
  libgbm,
  pkg-config,
  libglvnd,
  libxkbcommon,
  pipewire,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "epoch-${version}";
    hash = "sha256-4FdgavjxRKbU5/WBw9lcpWYLxCH6IJr7LaGkEXYUGbw=";
  };

  env.VERGEN_GIT_COMMIT_DATE = "2024-10-10";
  env.VERGEN_GIT_SHA = src.rev;

  useFetchCargoVendor = true;
  cargoHash = "sha256-FgfUkU9sv5mq4+pou2myQn6+DkLzPacjUhQ4pL8hntM=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    libglvnd
    libxkbcommon
    libgbm
    pipewire
    wayland
  ];
  checkInputs = [ gst_all_1.gstreamer ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  postInstall = ''
    mkdir -p $out/share/{dbus-1/services,icons,xdg-desktop-portal/portals}
    cp -r data/icons $out/share/icons/hicolor
    cp data/*.service $out/share/dbus-1/services/
    cp data/cosmic-portals.conf $out/share/xdg-desktop-portal/
    cp data/cosmic.portal $out/share/xdg-desktop-portal/portals/
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
