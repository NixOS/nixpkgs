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
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, buildPackages, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "pango";
  version = "1.50.14";

  outputs = [ "bin" "out" "dev" ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HWfyBb/DGMJ6Kc/ftoKFaN9WZ5XfDLUdIYnN5/LVgeg=";
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
    substituteInPlace meson.build \
      --replace "dependency('gi-docgen', ver" "dependency('gi-docgen', native:true, ver"

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
      packageName = pname;
      versionPolicy = "odd-unstable";
      # 1.90 is alpha for API 2.
      freeze = true;
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
  };
}
