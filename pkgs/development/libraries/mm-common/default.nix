{ stdenv
, fetchurl
, gnome3
, meson
, python3
, ninja
}:

stdenv.mkDerivation rec {
  pname = "mm-common";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1m4w33da9f4rx2d6kdj3ix3kl0gn16ml82v2mdn4hljr3q29nzdr";
  };

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Common build files of GLib/GTK C++ bindings";
    longDescription = ''
      The mm-common module provides the build infrastructure and utilities
      shared among the GNOME C++ binding libraries. It is only a required
      dependency for building the C++ bindings from the gnome.org version
      control repository. An installation of mm-common is not required for
      building tarball releases, unless configured to use maintainer-mode.
    '';
    homepage = "https://www.gtkmm.org";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
