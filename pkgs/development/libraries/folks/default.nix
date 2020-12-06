{ fetchurl
, stdenv
, pkgconfig
, meson
, ninja
, glib
, gnome3
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
  version = "0.14.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1f9b52vmwnq7s51vj26w2618dn2ph5g12ibbkbyk6fvxcgd7iryn";
  };

  mesonFlags = [
    "-Ddocs=true"
    "-Dtelepathy_backend=${stdenv.lib.boolToString telepathySupport}"
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gtk3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    db
    dbus-glib
    evolution-data-server
    libsecret
    libsoup
    libxml2
    nspr
    nss
    readline
  ] ++ stdenv.lib.optional telepathySupport telepathy-glib;

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

  doCheck = true;

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    patchShebangs tests/tools/manager-file.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "A library that aggregates people from multiple sources to create metacontacts";
    homepage = "https://wiki.gnome.org/Projects/Folks";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.gnu ++ platforms.linux; # arbitrary choice
  };
}
