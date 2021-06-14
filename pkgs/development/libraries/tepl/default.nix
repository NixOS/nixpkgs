{ lib, stdenv
, fetchurl
, meson
, ninja
, amtk
, gnome
, gobject-introspection
, gtk3
, gtksourceview4
, icu
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "tepl";
  version = "6.00.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qvs7s86gqyyrzi0r5fbrj8zczlgv8xhdjswgbgc1afwjnl9fqx8";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    pkg-config
  ];

  buildInputs = [
    icu
  ];

  propagatedBuildInputs = [
    amtk
    gtksourceview4
    gtk3
  ];

  doCheck = false;
  # TODO: one test fails because of
  # (./test-file-metadata:20931): Tepl-WARNING **: 14:41:36.942: GVfs metadata
  # is not supported. Fallback to TeplMetadataManager. Either GVfs is not
  # correctly installed or GVfs metadata are not supported on this platform. In
  # the latter case, you should configure Tepl with --disable-gvfs-metadata.

  passthru.updateScript = gnome.updateScript {
    packageName = pname;
    versionPolicy = "odd-unstable";
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Tepl";
    description = "Text editor product line";
    maintainers = teams.gnome.members ++ [ maintainers.manveru ];
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
