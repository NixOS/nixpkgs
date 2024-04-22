{ lib
, stdenv
, fetchurl
, fetchpatch2
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
  version = "1.2.1";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-EQXuB34hR/KgOc3fphb6XLlDiIPdlAQn4RaZ3NZUnBE=";
  };

  patches = [
    (fetchpatch2 {
      # Fix tests https://gitlab.gnome.org/GNOME/libshumate/-/merge_requests/236
      url = "https://gitlab.gnome.org/GNOME/libshumate/-/commit/852615b0df2252ea67f4f82e9ace2fc2794467b3.patch";
      hash = "sha256-Ksye3zNNYmzP4O+QFDVODXUkFJOLDVMEZNfGXwbxWhs=";
    })
  ];

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
