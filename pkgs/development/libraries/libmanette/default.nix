{ lib, stdenv
, fetchurl
, ninja
, meson
, mesonEmulatorHook
, pkg-config
, vala
, gobject-introspection
, buildPackages
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, libgudev
, libevdev
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libmanette";
  version = "0.2.9";

  outputs = [ "out" "dev" ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-KTZr5UUvYKdMZfxk/+LXTt3U5uaCTCzvpWekO9kraI8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ] ++ lib.optionals withIntrospection [
    vala
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libevdev
  ] ++ lib.optionals withIntrospection [
    libgudev
  ];

  mesonFlags = [
    (lib.mesonBool "doc" withIntrospection)
    (lib.mesonEnable "gudev" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Simple GObject game controller library";
    mainProgram = "manette-test";
    homepage = "https://gnome.pages.gitlab.gnome.org/libmanette/";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
