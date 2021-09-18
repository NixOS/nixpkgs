{ lib, stdenv
, desktop-file-utils
, nix-update-script
, elementary-gtk-theme
, elementary-icon-theme
, fetchFromGitHub
, flatpak
, gettext
, glib
, granite
, gtk3
, libgee
, libhandy
, meson
, ninja
, pantheon
, pkg-config
, python3
, vala
, libxml2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sideload";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0mwcaayzcm5pjcwdd61can93y66jiz4wyz9wr8j5fbns5hbk3z5m";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-gtk-theme
    elementary-icon-theme
    flatpak
    glib
    granite
    gtk3
    libgee
    libhandy
    libxml2
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    homepage = "https://github.com/elementary/sideload";
    description = "Flatpak installer, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
