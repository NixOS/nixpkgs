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
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, icu
, graphite2
, harfbuzz # The icu variant uses and propagates the non-icu one.
, ApplicationServices
, CoreText
, withCoreText ? false
, withIcu ? false # recommended by upstream as default, but most don't needed and it's big
, withGraphite2 ? true # it is small and major distros do include it
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
}:

stdenv.mkDerivation rec {
  pname = "harfbuzz${lib.optionalString withIcu "-icu"}";
  version = "7.1.0";

  src = fetchurl {
    url = "https://github.com/harfbuzz/harfbuzz/releases/download/${version}/harfbuzz-${version}.tar.xz";
    hash = "sha256-8TWmHNRkye1ryYI3ZMGI8nbDhQqNyQRijeKoeWa3B3s=";
  };

  postPatch = ''
    patchShebangs src/*.py test
  '' + lib.optionalString stdenv.isDarwin ''
    # ApplicationServices.framework headers have cast-align warnings.
    substituteInPlace src/hb.hh \
      --replace '#pragma GCC diagnostic error   "-Wcast-align"' ""
  '';

  outputs = [ "out" "dev" "devdoc" ];
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
    (lib.mesonEnable "introspection" withIntrospection)
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
    glib
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optional withIntrospection gobject-introspection;

  buildInputs = [ glib freetype ]
    ++ lib.optionals withCoreText [ ApplicationServices CoreText ];

  propagatedBuildInputs = lib.optional withGraphite2 graphite2
    ++ lib.optionals withIcu [ icu harfbuzz ];

  doCheck = true;

  # Slightly hacky; some pkgs expect them in a single directory.
  postFixup = lib.optionalString withIcu ''
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
  };

  meta = with lib; {
    description = "An OpenType text shaping engine";
    homepage = "https://harfbuzz.github.io/";
    maintainers = [ maintainers.eelco ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
