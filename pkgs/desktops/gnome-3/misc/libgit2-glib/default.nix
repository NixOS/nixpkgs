{ stdenv, fetchurl, gnome3, libtool, pkgconfig, vala, libssh2
, gtk-doc, gobjectIntrospection, libgit2, glib }:

stdenv.mkDerivation rec {
  name = "libgit2-glib-${version}";
  version = "0.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libgit2-glib/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "2ad6f20db2e38bbfdb6cb452704fe8a911036b86de82dc75bb0f3b20db40ce9c";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "libgit2-glib"; attrPath = "gnome3.libgit2-glib"; };
  };

  nativeBuildInputs = [
    gnome3.gnome-common libtool pkgconfig vala gtk-doc gobjectIntrospection
  ];

  propagatedBuildInputs = [
    # Required by libgit2-glib-1.0.pc
    libgit2 glib
  ];

  buildInputs = [ libssh2 ];

  meta = with stdenv.lib; {
    description = "A glib wrapper library around the libgit2 git access library";
    homepage = https://wiki.gnome.org/Projects/Libgit2-glib;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
