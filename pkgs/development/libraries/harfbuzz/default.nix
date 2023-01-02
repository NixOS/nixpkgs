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
  version = "5.3.1";

  src = fetchurl {
    url = "https://github.com/harfbuzz/harfbuzz/releases/download/${version}/harfbuzz-${version}.tar.xz";
    sha256 = "sha256-Smzgl7dagSH6zEuoO1sIO/7GV/RbADzVo0JPKua0Q00=";
  };

  patches = [
    # Pick upstream patch for exported symbol test failing on darwin
    # https://github.com/harfbuzz/harfbuzz/issues/3850
    (fetchpatch {
      name = "harfbuzz-fix-check-symbol-tests-lto-and-darwin.patch";
      url = "https://github.com/harfbuzz/harfbuzz/commit/b0b7a65388da25ae3fa01e969ad6abc67eed4f49.patch";
      sha256 = "0my064r88pikw6q70hbgf6hwfkw544b9f5ai73qhn2a3c83jqn06";
    })
  ];

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
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    libintl
    pkg-config
    python3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [ glib freetype gobject-introspection ]
    ++ lib.optionals withCoreText [ ApplicationServices CoreText ];

  propagatedBuildInputs = lib.optional withGraphite2 graphite2
    ++ lib.optionals withIcu [ icu harfbuzz ];

  doCheck = true;

  # Slightly hacky; some pkgs expect them in a single directory.
  postFixup = lib.optionalString withIcu ''
    rm "$out"/lib/libharfbuzz.* "$dev/lib/pkgconfig/harfbuzz.pc"
    ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.la
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
    platforms = with platforms; linux ++ darwin;
  };
}
