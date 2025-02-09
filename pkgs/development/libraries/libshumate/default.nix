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
, libsoup_3
, gtk4
, libsysprof-capture
, xvfb-run
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libshumate";
  version = "1.1.2";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libshumate";
    rev = version;
    sha256 = "g/82LQNwM/dwQ/zKDhAGtZE7JEtQ0jFWcylcP1azvSY=";
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
    libsoup_3
    gtk4
    libsysprof-capture
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  mesonFlags = [
    "-Ddemos=true"
  ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck

    env \
      HOME="$TMPDIR" \
      GTK_A11Y=none \
      xvfb-run meson test --print-errorlogs

    runHook postCheck
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/libshumate-1.0 "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GTK toolkit providing widgets for embedded maps";
    homepage = "https://gitlab.gnome.org/GNOME/libshumate";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
