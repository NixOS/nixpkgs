{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook4
, elementary-gtk-theme
, elementary-icon-theme
, glib
, granite7
, gtk4
, gtksourceview5
}:

stdenv.mkDerivation rec {
  pname = "elementary-iconbrowser";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "iconbrowser";
    rev = version;
    sha256 = "sha256-xooZfQmeB4rvlO8zKWnUuXPCFQNCTdjd7C53/j9EoHg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite7
    gtk4
    gtksourceview5
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/iconbrowser";
    description = "Browse and find system icons";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.iconbrowser";
  };
}
