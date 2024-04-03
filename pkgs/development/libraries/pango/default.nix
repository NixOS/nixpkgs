{ lib
, stdenv
, fetchurl
, pkg-config
, cairo
, harfbuzz
, libintl
, libthai
, darwin
, fribidi
, gnome
, gi-docgen
, makeFontsConf
, freefont_ttf
, meson
, ninja
, glib
, python3
, x11Support? !stdenv.isDarwin, libXft
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, buildPackages, gobject-introspection
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pango";
  version = "1.51.2";

  outputs = [ "bin" "out" "dev" ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = with finalAttrs; "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-PbpAfytfwRfhkvMCXwocyO3B/ZuTSxxXiyuXNCE5QVo=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson ninja
    glib # for glib-mkenum
    pkg-config
    python3
  ] ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    fribidi
    libthai
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
    Carbon
    CoreGraphics
    CoreText
  ]);

  propagatedBuildInputs = [
    cairo
    glib
    libintl
    harfbuzz
  ] ++ lib.optionals x11Support [
    libXft
  ];

  mesonFlags = [
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "xft" x11Support)
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  # Run-time dependency gi-docgen found: NO (tried pkgconfig and cmake)
  # it should be a build-time dep for build
  # TODO: send upstream
  postPatch = ''
    substituteInPlace docs/meson.build \
      --replace "'gi-docgen', req" "'gi-docgen', native:true, req"
  '';

  doCheck = false; # test-font: FAIL

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
      # 1.90 is alpha for API 2.
      freeze = "1.90.0";
    };
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = with lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';

    homepage = "https://www.pango.org/";
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin ] ++ teams.gnome.members;
    platforms = platforms.unix;

    pkgConfigModules = [
      "pango"
      "pangocairo"
      "pangofc"
      "pangoft2"
      "pangoot"
      "pangoxft"
    ];
  };
})
