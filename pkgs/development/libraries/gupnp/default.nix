{ stdenv
, lib
, fetchurl
, fetchpatch2
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

    # Unbreak build with Meson 1.2.0
    # https://gitlab.gnome.org/GNOME/gupnp/-/merge_requests/33
    (fetchpatch2 {
      name = "meson-1.2-fix.patch";
      url = "https://gitlab.gnome.org/GNOME/gupnp/-/commit/85c0244cfbf933d3e90d50ab68394c68d86f9ed5.patch";
      hash = "sha256-poDhkEgDTpgGnTbbZLPwx8Alf0h81vmzJyx3izWmDGw=";
    })

    # Fix build against libxml2 2.11
    # https://gitlab.gnome.org/GNOME/gupnp/-/merge_requests/34
    (fetchpatch2 {
      name = "libxml2-2.11-fix.patch";
      url = "https://gitlab.gnome.org/GNOME/gupnp/-/commit/bc56f02b0f89e96f2bd74af811903d9931965f58.patch";
      hash = "sha256-KCHlq7Es+WLIWKgIgGVTaHarVQIiZPEi5r6nMAhXTgY=";
    })

    # Fix build against libxml2 2.12
    # https://gitlab.gnome.org/GNOME/gupnp/-/merge_requests/35
    (fetchpatch2 {
      name = "libxml2-2.12-fix.patch";
      url = "https://gitlab.gnome.org/GNOME/gupnp/-/commit/387ca6714bcef64399e1bfdd599612cf3f9e75db.patch";
      hash = "sha256-Dy0kOOT27+HQIZBfEsOus9+ibLWc2Wtni63lAp7jIWw=";
    })
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
