{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  glib,
  granite,
  libgee,
  libhandy,
  libcanberra-gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = version;
    sha256 = "sha256-of7Tw38yJAhHKICU3XxGwIOwqfUhrL7SGKqFd9Dps/I=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
  ];

  postPatch = ''
    # https://github.com/elementary/notifications/issues/222
    substituteInPlace src/FdoActionGroup.vala \
      --replace-fail "out VariantType" "out unowned VariantType"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.notifications";
  };
}
