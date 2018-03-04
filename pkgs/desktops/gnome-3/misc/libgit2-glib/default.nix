{ stdenv, fetchurl, gnome3, libtool, pkgconfig, vala, libssh2
, gtk-doc, gobjectIntrospection, libgit2, glib }:

stdenv.mkDerivation rec {
  name = "libgit2-glib-${version}";
  version = "0.26.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libgit2-glib/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0nhyqas110q7ingw97bvyjdb7v4dzch517dq8sn8c33s8910wqcp";
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
