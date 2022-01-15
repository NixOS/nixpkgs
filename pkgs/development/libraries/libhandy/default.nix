{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, gsettings-desktop-schemas
, gtk3
, enableGlade ? false
, glade
, xvfb-run
, libxml2
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
, at-spi2-atk
, at-spi2-core
, gnome
, libhandy
, runCommand
}:

stdenv.mkDerivation rec {
  pname = "libhandy";
  version = "1.5.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ] ++ lib.optionals enableGlade [
    "glade"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-RmueAmwfnrO2WWb1MNl3A6ghLar5EXSMFF6cuEPb1v4=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
    libxml2
  ] ++ lib.optionals enableGlade [
    glade
  ];

  checkInputs = [
    xvfb-run
    at-spi2-atk
    at-spi2-core
    librsvg
    hicolor-icon-theme
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dglade_catalog=${if enableGlade then "enabled" else "disabled"}"
  ];

  # Uses define_variable in pkg-config, but we still need it to use the glade output
  PKG_CONFIG_GLADEUI_2_0_MODULEDIR = "${placeholder "glade"}/lib/glade/modules";
  PKG_CONFIG_GLADEUI_2_0_CATALOGDIR = "${placeholder "glade"}/share/glade/catalogs";

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck

    testEnvironment=(
      # Disable portal since we cannot run it in tests.
      HDY_DISABLE_PORTAL=1

      "XDG_DATA_DIRS=${lib.concatStringsSep ":" [
        # HdySettings needs to be initialized from “org.gnome.desktop.interface” GSettings schema when portal is not used for color scheme.
        # It will not actually be used since the “color-scheme” key will only have been introduced in GNOME 42, falling back to detecting theme name.
        # See hdy_settings_constructed function in https://gitlab.gnome.org/GNOME/libhandy/-/commit/bb68249b005c445947bfb2bee66c91d0fe9c41a4
        (glib.getSchemaDataDirPath gsettings-desktop-schemas)

        # Some tests require icons
        "${hicolor-icon-theme}/share"
      ]}"
    )
    env "''${testEnvironment[@]}" xvfb-run \
      meson test --print-errorlogs

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  } // lib.optionalAttrs (!enableGlade) {
    glade =
      let
        libhandyWithGlade = libhandy.override {
          enableGlade = true;
        };
      in runCommand "${libhandy.name}-glade" {} ''
        cp -r "${libhandyWithGlade.glade}" "$out"
        chmod -R +w "$out"
        sed -e "s#${libhandyWithGlade.out}#${libhandy.out}#g" -e "s#${libhandyWithGlade.glade}#$out#g" -i $(find "$out" -type f)
      '';
  };

  meta = with lib; {
    changelog = "https://gitlab.gnome.org/GNOME/libhandy/-/tags/${version}";
    description = "Building blocks for modern adaptive GNOME apps";
    homepage = "https://gitlab.gnome.org/GNOME/libhandy";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
