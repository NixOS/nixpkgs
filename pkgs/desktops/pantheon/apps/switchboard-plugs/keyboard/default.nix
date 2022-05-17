{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, gnome-settings-daemon
, granite
, gsettings-desktop-schemas
, gtk3
, libhandy
, libxml2
, libgnomekbd
, libxklavier
, ibus
, onboard
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-DofAOv7sCe7RAJpgz9PEYm+C8RAl0a1KgFm9jToMsEY=";
  };

  patches = [
    ./0001-Remove-Install-Unlisted-Engines-function.patch
    (substituteAll {
      src = ./fix-paths.patch;
      inherit ibus onboard libgnomekbd;
    })

    # Revert schema key change that requires new GSD and Gala.
    # TODO(@bobby285271): drop these in #196511.
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-keyboard/commit/555e9650bb8f74a7664e2393c589fe6664954a88.patch";
      sha256 = "sha256-koSTYLPRh9rOyxmJPtrj/fPuu2jb1SKZu6BwKsMvAmc=";
      revert = true;
    })
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-keyboard/commit/6ebd57673b45cc64e1caf895134efc0d5f6cf2be.patch";
      sha256 = "sha256-Ezsh0t1/909MHCB2EJEnl4kcnXngshNYgrmqUQsfsaY=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gnome-settings-daemon # media-keys
    granite
    gsettings-desktop-schemas
    gtk3
    ibus
    libgee
    libhandy
    libxklavier
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
