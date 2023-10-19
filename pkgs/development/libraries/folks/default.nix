{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, glib
, gnome
, gettext
, gobject-introspection
, vala
, sqlite
, dbus-glib
, dbus
, libgee
, evolution-data-server-gtk4
, python3
, readline
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, telepathy-glib
, telepathySupport ? false
}:

# TODO: enable more folks backends

stdenv.mkDerivation rec {
  pname = "folks";
  version = "0.15.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "yGZjDFU/Kc6b4cemAmfLQICmvM9LjVUdxMfmI02EAkg=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    meson
    ninja
    pkg-config
    vala
  ] ++ lib.optionals telepathySupport [
    python3
  ];

  buildInputs = [
    dbus-glib
    evolution-data-server-gtk4 # UI part not needed, using gtk4 version to reduce system closure.
    readline
  ] ++ lib.optionals telepathySupport [
    telepathy-glib
  ];

  propagatedBuildInputs = [
    glib
    libgee
    sqlite
  ];

  nativeCheckInputs = [
    dbus
    (python3.withPackages (pp: with pp; [
      python-dbusmock
      # The following possibly need to be propagated by dbusmock
      # if they are not optional
      dbus-python
      pygobject3
    ]))
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dtelepathy_backend=${lib.boolToString telepathySupport}"
    # For some reason, the tests are getting stuck on 31/32,
    # even though the one missing test finishes just fine on next run,
    # when tests are permuted differently. And another test that
    # previously passed will be stuck instead.
    "-Dtests=false"
  ];

  doCheck = false;

  # Prevents e-d-s add-contacts-stress-test from timing out
  checkPhase = ''
    runHook preCheck
    meson test --timeout-multiplier 4
    runHook postCheck
  '';

  postPatch = lib.optionalString telepathySupport ''
    patchShebangs tests/tools/manager-file.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that aggregates people from multiple sources to create metacontacts";
    homepage = "https://wiki.gnome.org/Projects/Folks";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
