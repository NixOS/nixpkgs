{ stdenv
, lib
, fetchFromGitHub
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
  version = "0.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = version;
    sha256 = "oPPO2f6NNeok0SGh4jELkkOP6VUxXZiwPM/n6CUHm0Q=";
  };

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
    platforms = platforms.linux;
  };
}
