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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-iS+xTCjbRZfaUiOtHbQ+/SaajfWWAlC9XiZbIGZPO9I=";
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
