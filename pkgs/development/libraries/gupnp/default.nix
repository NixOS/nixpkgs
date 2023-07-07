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
, docbook_xml_dtd_412
, docbook_xml_dtd_45
, glib
, gssdp
, libsoup
, libxml2
, libuuid
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gupnp";
  version = "1.4.4";

  outputs = [ "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-N2GxXLBjYh+Efz7/t9djfwMXUA/Ka9oeGQT3OSF1Ch8=";
  };

  patches = [
    # Bring .pc file in line with our patched pkg-config.
    ./0001-pkg-config-Declare-header-dependencies-as-public.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    docbook_xml_dtd_45
  ];

  buildInputs = [
    libuuid
  ];

  propagatedBuildInputs = [
    glib
    gssdp
    libsoup
    libxml2
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  # Bail out! ERROR:../tests/test-bugs.c:168:test_on_timeout: code should not be reached
  doCheck = !stdenv.isDarwin;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "http://www.gupnp.org/";
    description = "An implementation of the UPnP specification";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
