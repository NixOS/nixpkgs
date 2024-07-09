{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gi-docgen
, glib
, gtk4
, gtksourceview5
, enchant
, icu
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "libspelling";
  version = "0.2.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "libspelling";
    rev = version;
    hash = "sha256-0OGcwPGWtYYf0XmvzXEaQgebBOW/6JWcDuF4MlQjCZQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ];

  buildInputs = [
    glib
    gtk4
    gtksourceview5
    enchant
    icu
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Spellcheck library for GTK 4";
    homepage = "https://gitlab.gnome.org/chergert/libspelling";
    license = licenses.lgpl21Plus;
    changelog = "https://gitlab.gnome.org/chergert/libspelling/-/raw/${version}/NEWS";
    maintainers = with maintainers; [ chuangzhu ];
  };
}
