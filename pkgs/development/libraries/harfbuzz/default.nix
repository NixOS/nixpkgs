{ stdenv, fetchFromGitHub, pkgconfig, glib, freetype, cairo, libintl
, meson, ninja
, gobject-introspection
, icu, graphite2, harfbuzz # The icu variant uses and propagates the non-icu one.
, ApplicationServices, CoreText
, withCoreText ? false
, withIcu ? false # recommended by upstream as default, but most don't needed and it's big
, withGraphite2 ? true # it is small and major distros do include it
, python3
, gtk-doc, docbook-xsl-nons, docbook_xml_dtd_43
}:

let
  version = "2.7.2";
  inherit (stdenv.lib) optional optionals optionalString;
  mesonFeatureFlag = opt: b:
    "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation {
  name = "harfbuzz${optionalString withIcu "-icu"}-${version}";

  src = fetchFromGitHub {
    owner  = "harfbuzz";
    repo   = "harfbuzz";
    rev    = version;
    sha256 = "0vfyxr3lvzp80j1347nrwpr1ndv265p15rj2q8rj31lb26nyz4dm";
  };

  postPatch = ''
    patchShebangs src/*.py
    patchShebangs test
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # ApplicationServices.framework headers have cast-align warnings.
    substituteInPlace src/hb.hh \
      --replace '#pragma GCC diagnostic error   "-Wcast-align"' ""
  '';

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  mesonFlags = [
    (mesonFeatureFlag "graphite" withGraphite2)
    (mesonFeatureFlag "icu" withIcu)
    (mesonFeatureFlag "coretext" withCoreText)
  ];

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    libintl
    pkgconfig
    python3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [ glib freetype cairo ] # recommended by upstream
    ++ stdenv.lib.optionals withCoreText [ ApplicationServices CoreText ];

  propagatedBuildInputs = []
    ++ optional withGraphite2 graphite2
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

  meta = with stdenv.lib; {
    description = "An OpenType text shaping engine";
    homepage = "https://harfbuzz.github.io/";
    maintainers = [ maintainers.eelco ];
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
  };
}
