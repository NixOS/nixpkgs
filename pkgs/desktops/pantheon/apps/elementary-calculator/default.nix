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
, granite7
, gtk4
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-calculator";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calculator";
    rev = version;
    sha256 = "sha256-PLdPu43ns03vhBwaGw4BWCLNvcJbhUA+5Gr5b//TqfA=";
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
    granite7
    gtk4
    libgee
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
    homepage = "https://github.com/elementary/calculator";
    description = "Calculator app designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calculator";
  };
}
