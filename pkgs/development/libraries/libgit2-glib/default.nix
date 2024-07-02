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
, fetchpatch2
}:

stdenv.mkDerivation rec {
  pname = "libgit2-glib";
  version = "1.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "EzHa2oOPTh9ZGyZFnUQSajJd52LcPNJhU6Ma+9/hgZA=";
  };

  patches = [
    (fetchpatch2 {
      name = "support-libgit2-1.8.patch";
      url = "https://github.com/GNOME/libgit2-glib/pull/4/commits/304a8c3fae1784d665e92c1ce2143c66d7ecf47f.patch";
      hash = "sha256-OICFr9gt98rv1qlCdVSXJO0a55l8rIMffoXrGKYuN8E=";
    })
  ];

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
    chmod +x meson_python_compile.py
    patchShebangs meson_python_compile.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Glib wrapper library around the libgit2 git access library";
    homepage = "https://gitlab.gnome.org/GNOME/libgit2-glib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
