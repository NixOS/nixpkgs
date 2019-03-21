{ stdenv, fetchurl, gnome3 }:

stdenv.mkDerivation rec {
  pname = "mm-common";
  version = "0.9.12";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "02vwgv404b56wxy0gnm9xq9fvzgn9dhfqcy2hhl78ljv3v7drzyf";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Common build files of GLib/GTK+ C++ bindings";
    longDescription = ''
      The mm-common module provides the build infrastructure and utilities
      shared among the GNOME C++ binding libraries. It is only a required
      dependency for building the C++ bindings from the gnome.org version
      control repository. An installation of mm-common is not required for
      building tarball releases, unless configured to use maintainer-mode.
    '';
    homepage = http://www.gtkmm.org;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
