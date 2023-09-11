{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gtk-doc
, docbook_xsl
, glib
, mesonEmulatorHook
, gnome
}:

# TODO: Add installed tests once https://gitlab.gnome.org/World/libcloudproviders/issues/4 is fixed

stdenv.mkDerivation rec {
  pname = "libcloudproviders";
  version = "0.3.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libcloudproviders/${lib.versions.majorMinor version}/libcloudproviders-${version}.tar.xz";
    sha256 = "49cWDD5F/jIWwHx5iLtPyBOXwy0fxhE68O3+hjIDn2U=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [ glib ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libcloudproviders";
    };
  };

  meta = with lib; {
    description = "DBus API that allows cloud storage sync clients to expose their services";
    homepage = "https://gitlab.gnome.org/World/libcloudproviders";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
