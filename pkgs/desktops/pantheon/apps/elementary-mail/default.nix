{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, vala
, gtk3
, libxml2
, libhandy
, libportal-gtk3
, webkitgtk_4_1
, elementary-gtk-theme
, elementary-icon-theme
, folks
, glib-networking
, granite
, evolution-data-server
, wrapGAppsHook
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-mail";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = version;
    sha256 = "sha256-hBOogZ9ZNS9KnuNn+jNhTtlupBxZL2DG/CiuBR1kFu0=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    evolution-data-server
    folks
    glib-networking
    granite
    gtk3
    libgee
    libhandy
    libportal-gtk3
    webkitgtk_4_1
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
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ethancedwards8 ] ++ teams.pantheon.members;
    mainProgram = "io.elementary.mail";
  };
}
