{ stdenv
, lib
, fetchurl
, meson
, mesonEmulatorHook
, ninja
, gnome
, gobject-introspection
, gtk3
, icu
, libgedit-amtk
, libgedit-gtksourceview
, pkg-config
, gtk-doc
, docbook-xsl-nons
}:

stdenv.mkDerivation rec {
  pname = "tepl";
  version = "6.8.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Rubl8b/bxS5ZVvBq3VdenHaXxnPVPTgD3+do9JC1YPA=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    pkg-config
    gtk-doc
    docbook-xsl-nons
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    icu
  ];

  propagatedBuildInputs = [
    gtk3
    libgedit-amtk
    libgedit-gtksourceview
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
    maintainers = with maintainers; [ manveru bobby285271 ];
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
