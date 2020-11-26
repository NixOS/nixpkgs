{ stdenv
, fetchurl
, pkgconfig
, glib
, gobject-introspection
, meson
, ninja
, python3
  # just for passthru
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gsettings-desktop-schemas";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rwcg9sd5rv7gjwapcd1jjk6l16w0p3j7wkicq1rdch4c0kch12p";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkgconfig
    python3
  ];

  buildInputs = [
    glib
    gobject-introspection
  ];

  postPatch = ''
    chmod +x build-aux/meson/post-install.py
    patchShebangs build-aux/meson/post-install.py
  '';

  # meson installs the schemas to share/glib-2.0/schemas
  # We add the override file there too so it will be compiled and later moved by
  # glib's setup hook.
  preInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cat - > $out/share/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Collection of GSettings schemas for settings shared by various components of a desktop";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
  };
}
