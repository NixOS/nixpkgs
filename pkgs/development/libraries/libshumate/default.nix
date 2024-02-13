{ lib
, stdenv
, fetchurl
, gi-docgen
, meson
, ninja
, pkg-config
, vala
, gobject-introspection
, gperf
, glib
, cairo
, sqlite
, libsoup_3
, gtk4
, libsysprof-capture
, json-glib
, protobufc
, xvfb-run
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libshumate";
  version = "1.2.0";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-T4QTpwfNAPhM7jnKSfWMSPxDbwCOqA1lMqw32v0LqWs=";
  };

  depsBuildBuild = [
    # required to find native gi-docgen when cross compiling
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    gperf
  ];

  buildInputs = [
    glib
    cairo
    sqlite
    libsoup_3
    gtk4
    libsysprof-capture
    json-glib
    protobufc
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  mesonFlags = [
    "-Ddemos=true"
  ];

  # Disable until upstream resolves tests failing in release builds
  # https://gitlab.gnome.org/GNOME/libshumate/-/issues/71
  doCheck = false;

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
    };
  };

  meta = with lib; {
    description = "GTK toolkit providing widgets for embedded maps";
    mainProgram = "shumate-demo";
    homepage = "https://gitlab.gnome.org/GNOME/libshumate";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
