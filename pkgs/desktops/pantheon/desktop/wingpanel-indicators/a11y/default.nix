{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, granite
, gtk3
, libgee
, wingpanel
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-a11y";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-HECK+IEUAKJ4F1TotTHF84j4BYS6EZdAtLBoM401+mw=";
=======
    sha256 = "sha256-iS+xTCjbRZfaUiOtHbQ+/SaajfWWAlC9XiZbIGZPO9I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Universal Access Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-a11y";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
