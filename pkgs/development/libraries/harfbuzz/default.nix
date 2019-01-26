{ stdenv, fetchurl, pkgconfig, glib, freetype, cairo, libintl
, icu, graphite2, harfbuzz # The icu variant uses and propagates the non-icu one.
, ApplicationServices, CoreText
, withCoreText ? false
, withIcu ? false # recommended by upstream as default, but most don't needed and it's big
, withGraphite2 ? true # it is small and major distros do include it
, python
}:

let
  version = "2.3.0";
  inherit (stdenv.lib) optional optionals optionalString;
in

stdenv.mkDerivation {
  name = "harfbuzz${optionalString withIcu "-icu"}-${version}";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${version}.tar.bz2";
    sha256 = "0r37z5cn04ig0q47y8c26gvadz15z9jj8c8q3r41j7d4anv4sc9v";
  };

  postPatch = ''
    patchShebangs src/gen-def.py
    patchShebangs test
  '';

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  configureFlags = [
    # not auto-detected by default
    "--with-graphite2=${if withGraphite2 then "yes" else "no"}"
    "--with-icu=${if withIcu then "yes" else "no"}"
  ]
    ++ stdenv.lib.optional withCoreText "--with-coretext=yes";

  nativeBuildInputs = [ pkgconfig libintl ];

  buildInputs = [ glib freetype cairo ] # recommended by upstream
    ++ stdenv.lib.optionals withCoreText [ ApplicationServices CoreText ];

  propagatedBuildInputs = []
    ++ optional withGraphite2 graphite2
    ++ optionals withIcu [ icu harfbuzz ];

  checkInputs = [ python ];
  doInstallCheck = false; # fails, probably a bug

  # Slightly hacky; some pkgs expect them in a single directory.
  postInstall = optionalString withIcu ''
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
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    downloadPage = "https://www.freedesktop.org/software/harfbuzz/release/";
    maintainers = [ maintainers.eelco ];
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    inherit version;
    updateWalker = true;
  };
}
