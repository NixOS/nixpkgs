{ lib
, stdenv
, fetchFromGitHub
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
}:

let
  version = "2.8.1";
  inherit (lib) optional optionals optionalString;
  mesonFeatureFlag = opt: b:
    "-D${opt}=${if b then "enabled" else "disabled"}";
  isNativeCompilation = stdenv.buildPlatform == stdenv.hostPlatform;
in

stdenv.mkDerivation {
  name = "harfbuzz${optionalString withIcu "-icu"}-${version}";

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "harfbuzz";
    rev = version;
    sha256 = "107l9jhvwy6pnq5032kr7r21md65qg09j7iikr4jihf9pvh7gn5w";
  };

  postPatch = ''
    patchShebangs src/*.py
    patchShebangs test
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
    (mesonFeatureFlag "introspection" isNativeCompilation)
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

  buildInputs = [ glib freetype ]
    ++ lib.optionals withCoreText [ ApplicationServices CoreText ]
    ++ lib.optionals isNativeCompilation [ gobject-introspection ];

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

  meta = with lib; {
    description = "An OpenType text shaping engine";
    homepage = "https://harfbuzz.github.io/";
    maintainers = [ maintainers.eelco ];
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
  };
}
