{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gi-docgen
, glib
, gtk3
, gtk4
, libsForQt5
, variant ? null
}:

assert variant == null || variant == "gtk3" || variant == "gtk4" || variant == "qt5";

stdenv.mkDerivation rec {
  pname = "libportal" + lib.optionalString (variant != null) "-${variant}";
  version = "0.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = version;
    sha256 = "sha256-wDDE43UC6FBgPYLS+WWExeheURCH/3fCKu5oJg7GM+A=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-on-darwin.patch";
      url = "https://github.com/flatpak/libportal/pull/106/commits/73f63ee57669c4fa604a7772484cd235d4fb612c.patch";
      sha256 = "sha256-c9WUQPhn4IA3X1ie7SwnxuZXdvpPkpGdU4xgDwKN/L0=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gi-docgen
  ] ++ lib.optionals (variant != "qt5") [
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    glib
  ] ++ lib.optionals (variant == "gtk3") [
    gtk3
  ] ++ lib.optionals (variant == "gtk4") [
    gtk4
  ] ++ lib.optionals (variant == "qt5") [
    libsForQt5.qtbase
  ];

  mesonFlags = [
    "-Dbackends=${lib.optionalString (variant != null) variant}"
    "-Dvapi=${if variant != "qt5" then "true" else "false"}"
    "-Dintrospection=${if variant != "qt5" then "true" else "false"}"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
