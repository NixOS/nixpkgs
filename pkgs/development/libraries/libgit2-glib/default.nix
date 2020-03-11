{ stdenv, fetchurl, gnome3, meson, ninja, pkgconfig, vala, libssh2
, gtk-doc, gobject-introspection, libgit2, glib, python3 }:

stdenv.mkDerivation rec {
  pname = "libgit2-glib";
  version = "0.99.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1pmrcnsa7qdda73c3dxf47733mwprmj5ljpw3acxbj6r8k27anp0";
  };

  postPatch = ''
    for f in meson_vapi_link.py meson_python_compile.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala gtk-doc gobject-introspection
  ];

  propagatedBuildInputs = [
    # Required by libgit2-glib-1.0.pc
    libgit2 glib
  ];

  buildInputs = [
    libssh2
    python3.pkgs.pygobject3 # this should really be a propagated input of python output
  ];

  meta = with stdenv.lib; {
    description = "A glib wrapper library around the libgit2 git access library";
    homepage = "https://wiki.gnome.org/Projects/Libgit2-glib";
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
