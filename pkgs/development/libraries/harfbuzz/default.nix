{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, glib
, freetype
, fontconfig
, libintl
, meson
, ninja
, gobject-introspection
, buildPackages
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, icu
, graphite2
, harfbuzz # The icu variant uses and propagates the non-icu one.
, ApplicationServices
, CoreText
, withCoreText ? false
, withIcu ? stdenv.hostPlatform.isMinGW # recommended by upstream as default, but most don't needed and it's big
, withGlib ? lib.meta.availableOn stdenv.hostPlatform glib
, withGraphite2 ? lib.meta.availableOn stdenv.hostPlatform graphite2 # it is small and major distros do include it
, python3
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
  # for passthru.tests
, gimp
, gtk3
, gtk4
, mapnik
, qt5
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harfbuzz${lib.optionalString withIcu "-icu"}";
  version = "7.3.0";

  src = fetchurl {
    url = "https://github.com/harfbuzz/harfbuzz/releases/download/${finalAttrs.version}/harfbuzz-${finalAttrs.version}.tar.xz";
    hash = "sha256-IHcHiXSaybqEbfM5g9vaItuDbHDZ9dBQy5qlNHCUqPs=";
  };

  postPatch = ''
    patchShebangs src/*.py test
  '' + lib.optionalString stdenv.isDarwin ''
    # ApplicationServices.framework headers have cast-align warnings.
    substituteInPlace src/hb.hh \
      --replace '#pragma GCC diagnostic error   "-Wcast-align"' ""
  '';

  outputs = [ "out" "dev" ]
    ++ lib.optional withIntrospection "devdoc";
  outputBin = "dev";

  mesonFlags = [
    # upstream recommends cairo, but it is only used for development purposes
    # and is not part of the library.
    # Cairo causes transitive (build) dependencies on various X11 or other
    # GUI-related libraries, so it shouldn't be re-added lightly.
    (lib.mesonEnable "cairo" false)
    # chafa is only used in a development utility, not in the library
    (lib.mesonEnable "chafa" false)
    (lib.mesonEnable "coretext" withCoreText)
    (lib.mesonEnable "graphite" withGraphite2)
    (lib.mesonEnable "icu" withIcu)
    (lib.mesonEnable "gobject" withIntrospection)
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "glib" withGlib)
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    libintl
    pkg-config
    python3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optional withIntrospection gobject-introspection
  ++ lib.optional withGlib glib;

  buildInputs = [ freetype ]
    ++ lib.optionals withGlib [ glib ]
    ++ lib.optionals withCoreText [ ApplicationServices CoreText ];

  propagatedBuildInputs = lib.optional withGraphite2 graphite2
    ++ lib.optionals withIcu [ icu ]
    ++ lib.optionals (withIcu && !stdenv.hostPlatform.isMinGW) [ harfbuzz ];

  doCheck = true;

  # Slightly hacky; some pkgs expect them in a single directory.
  postFixup = lib.optionalString (withIcu && !stdenv.hostPlatform.isMinGW) ''
    rm "$out"/lib/libharfbuzz.* "$dev/lib/pkgconfig/harfbuzz.pc"
    ln -s {'${harfbuzz.dev}',"$dev"}/lib/pkgconfig/harfbuzz.pc
    ${lib.optionalString stdenv.isDarwin ''
      ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.dylib
      ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.0.dylib
    ''}
  '';

  passthru.tests = {
    inherit gimp gtk3 gtk4 mapnik;
    inherit (qt5) qtbase;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "An OpenType text shaping engine";
    homepage = "https://harfbuzz.github.io/";
    changelog = "https://github.com/harfbuzz/harfbuzz/raw/${version}/NEWS";
    maintainers = [ maintainers.eelco ];
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
    pkgConfigModules = [
      "harfbuzz"
      "harfbuzz-gobject"
      "harfbuzz-subset"
    ];
  };
})
