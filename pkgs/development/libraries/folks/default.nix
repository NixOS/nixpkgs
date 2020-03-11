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
, telepathy-glib
, evolution-data-server
, libsecret
, db
, python3
, readline
, gtk3
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
}:

# TODO: enable more folks backends

stdenv.mkDerivation rec {
  pname = "folks";
  version = "0.13.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0wq14yjs7m3axziy679a854vc7r7fj1l38p9jnyapb21vswdcqq2";
  };

  mesonFlags = [
    "-Ddocs=true"
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
    telepathy-glib
  ];

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
    homepage = https://wiki.gnome.org/Projects/Folks;
    license = licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.gnu ++ platforms.linux;  # arbitrary choice
  };
}
