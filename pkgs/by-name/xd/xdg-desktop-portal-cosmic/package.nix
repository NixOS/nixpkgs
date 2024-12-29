{
  fetchFromGitHub,
  gst_all_1,
  lib,
  libcosmicAppHook,
  mesa,
  pipewire,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-4FdgavjxRKbU5/WBw9lcpWYLxCH6IJr7LaGkEXYUGbw=";
  };
  # Match this to the git commit SHA matching the `src.rev`
  env.VERGEN_GIT_SHA = "e7c92a7316ad5c6e0ccfa08adaae118ee8f2738f";
  # Match this to the commit date of `src.rev` in the format 'YYYY-MM-DD'
  env.VERGEN_GIT_COMMIT_DATE = "2024-12-04";

  useFetchCargoVendor = true;
  cargoHash = "sha256-FgfUkU9sv5mq4+pou2myQn6+DkLzPacjUhQ4pL8hntM=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
    rustPlatform.bindgenHook
  ];

  separateDebugInfo = true;
  buildInputs = [
    mesa
    pipewire
  ];

  checkInputs = [ gst_all_1.gstreamer ];

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
    platforms = platforms.linux;
    mainProgram = "xdg-desktop-portal-cosmic";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
