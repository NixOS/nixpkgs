{ lib
, stdenv
, fetchFromGitLab
, gi-docgen
, meson
, ninja
, pkg-config
, vala
, gobject-introspection
, glib
, cairo
, sqlite
, libsoup
, gtk4
, xvfb-run
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libshumate";
  version = "unstable-2021-10-06";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libshumate";
    rev = "7a0a03f299881e8faaac7d904cc47b74795ae5dd";
    sha256 = "df8ZHn/wmkzaYH0L3E6ULUtqxqU71EqL0jSgKhWqlT8=";
  };

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    cairo
    sqlite
    libsoup
    gtk4
  ];

  checkInputs = [
    xvfb-run
  ];

  mesonFlags = [
    "-Ddemos=true"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    HOME=$TMPDIR xvfb-run meson test --print-errorlogs

    runHook postCheck
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/libshumate-0.0 "$devdoc"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = meta.homepage;
  };

  meta = with lib; {
    description = "GTK toolkit providing widgets for embedded maps";
    homepage = "https://gitlab.gnome.org/GNOME/libshumate";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
