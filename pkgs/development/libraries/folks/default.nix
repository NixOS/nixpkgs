{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, glib
, gnome
, nspr
, gettext
, gobject-introspection
, vala
, sqlite
, libxml2
, dbus-glib
, libsoup
, nss
, dbus
, libgee
, evolution-data-server
, libgdata
, libsecret
, db
, python3
, readline
, gtk3
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, telepathy-glib
, telepathySupport ? false
}:

# TODO: enable more folks backends

stdenv.mkDerivation rec {
  pname = "folks";
  version = "0.15.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "D/+KiWMwzYKu5FmDJPflQciE0DN1NiEnI7S+s4x1kIY=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gtk3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    db
    dbus-glib
    evolution-data-server
    libgdata # required for some backends transitively
    libsecret
    libsoup
    libxml2
    nspr
    nss
    readline
  ] ++ lib.optional telepathySupport telepathy-glib;

  propagatedBuildInputs = [
    glib
    libgee
    sqlite
  ];

  checkInputs = [
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

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
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
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.gnu ++ platforms.linux; # arbitrary choice
  };
}
