{ lib
, stdenv
, fetchFromGitHub
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

let
  version = "5.1.0";
  inherit (lib) optional optionals optionalString;
  mesonFeatureFlag = opt: b:
    "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation {
  pname = "harfbuzz${optionalString withIcu "-icu"}";
  inherit version;

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "harfbuzz";
    rev = version;
    sha256 = "sha256-K6iScmg1vNfwb1UYqtXsnijLVpcC+am2ZL+W5bLFzsI=";
  };

  patches = [
    (fetchpatch {
      name = "aarch64-test-narrowing.diff";
      url = "https://github.com/harfbuzz/harfbuzz/commit/04d28d94e576aab099891e6736fd0088dfac3366.diff";
      sha256 = "sha256-099GP8t1G0kyYl79A6xJhfyrs3WXYitvn+He7sEz+Oo=";
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
    (mesonFeatureFlag "cairo" false)
    # chafa is only used in a development utility, not in the library
    (mesonFeatureFlag "chafa" false)
    (mesonFeatureFlag "coretext" withCoreText)
    (mesonFeatureFlag "graphite" withGraphite2)
    (mesonFeatureFlag "icu" withIcu)
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

  propagatedBuildInputs = optional withGraphite2 graphite2
    ++ optionals withIcu [ icu harfbuzz ];

  doCheck = true;

  # Slightly hacky; some pkgs expect them in a single directory.
  postFixup = optionalString withIcu ''
    rm "$out"/lib/libharfbuzz.* "$dev/lib/pkgconfig/harfbuzz.pc"
    ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.la
    ln -s {'${harfbuzz.dev}',"$dev"}/lib/pkgconfig/harfbuzz.pc
    ${optionalString stdenv.isDarwin ''
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
