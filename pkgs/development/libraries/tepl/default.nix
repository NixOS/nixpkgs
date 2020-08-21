{ stdenv
, fetchurl
, meson
, ninja
, amtk
, gnome3
, gobject-introspection
, gtk3
, gtksourceview4
, icu
, libuchardet
, libxml2
, pkg-config
}:
let
  version = "4.99.3";
  pname = "tepl";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mribr59n2isf1is6n849g3xpwmxm71xj1npaap30m8cy0sfdbz4";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    pkg-config
  ];

  buildInputs = [
    icu
    libxml2
  ];

  propagatedBuildInputs = [
    amtk
    gtksourceview4
    libuchardet
    gtk3
  ];

  doCheck = false;
  # TODO: one test fails because of
  # (./test-file-metadata:20931): Tepl-WARNING **: 14:41:36.942: GVfs metadata
  # is not supported. Fallback to TeplMetadataManager. Either GVfs is not
  # correctly installed or GVfs metadata are not supported on this platform. In
  # the latter case, you should configure Tepl with --disable-gvfs-metadata.

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Tepl";
    description = "Text editor product line";
    maintainers = [ maintainers.manveru ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
