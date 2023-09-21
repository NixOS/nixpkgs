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
}:

stdenv.mkDerivation rec {
  pname = "libspelling";
  version = "0.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "libspelling";
    rev = version;
    hash = "sha256-R3nPs16y8XGamQvMSF7wb52h0jxt17H2FZPwauLDI/c=";
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

  meta = with lib; {
    description = "Spellcheck library for GTK 4";
    homepage = "https://gitlab.gnome.org/chergert/libspelling";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
