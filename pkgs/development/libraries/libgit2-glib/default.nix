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
, fetchpatch
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
    (fetchpatch {
      name = "support-libgit2-1.8.patch";
      # https://gitlab.gnome.org/GNOME/libgit2-glib/-/merge_requests/40
      url = "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/a76fdf96c3af9ce9d21a3985c4be8a1aa6eea661.patch";
      hash = "sha256-ysU8pAixyftensfEC9bE0RUFMPMei0jYT26WKN5uOFE=";
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
