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
, at-spi2-core
, dbus
, xvfb-run
, gnome
}:

let
  at-spi2-core' = at-spi2-core.overrideAttrs (attrs: {
    mesonFlags = attrs.mesonFlags ++ [
      # Original package looks for it on system path for closure size reasons
      # but that is not available inside build sandbox.
      "-Ddbus_daemon=${dbus}/bin/dbus-daemon"
    ];
  });
in
let
  at-spi2-core = at-spi2-core';
in
stdenv.mkDerivation rec {
  pname = "libshumate";
  version = "1.0.3";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libshumate";
    rev = version;
    sha256 = "gT6jpFN0mkSdDs+8GQa0qKuL5KLzxanBMGwA4EATW7Y=";
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
  ];

  nativeCheckInputs = [
    dbus
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
      xvfb-run \
      dbus-run-session \
        --config-file=${dbus}/share/dbus-1/session.conf \
        sh -c '
          ${at-spi2-core}/libexec/at-spi-bus-launcher --launch-immediately &
          meson test --print-errorlogs
        '

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
