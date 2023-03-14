{ stdenv
, lib
, fetchurl
, gnome
, meson
, ninja
, pkg-config
, vala
, libssh2
, gtk-doc
, gobject-introspection
, gi-docgen
, libgit2
, glib
, python3
}:

stdenv.mkDerivation rec {
  pname = "libgit2-glib";
  version = "1.1.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "w43XV12vgUHh5CIzOldfr2XzySEMCOg+mBuI3UG/HvM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gtk-doc
    gobject-introspection
    gi-docgen
  ];

  propagatedBuildInputs = [
    # Required by libgit2-glib-1.0.pc
    libgit2
    glib
  ];

  buildInputs = [
    libssh2
    python3.pkgs.pygobject3 # this should really be a propagated input of python output
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    for f in meson_vapi_link.py meson_python_compile.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A glib wrapper library around the libgit2 git access library";
    homepage = "https://wiki.gnome.org/Projects/Libgit2-glib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
