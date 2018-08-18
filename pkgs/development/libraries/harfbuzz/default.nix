{ stdenv, fetchurl, pkgconfig, glib, freetype, cairo, libintl
, icu, graphite2, harfbuzz # The icu variant uses and propagates the non-icu one.
, withIcu ? false # recommended by upstream as default, but most don't needed and it's big
, withGraphite2 ? true # it is small and major distros do include it
}:

let
  version = "1.8.2";
  inherit (stdenv.lib) optional optionals optionalString;
in

stdenv.mkDerivation {
  name = "harfbuzz${optionalString withIcu "-icu"}-${version}";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${version}.tar.bz2";
    sha256 = "0my6m9aqv4a8fc2pjwqx9pfdfh3a9mqvas4si4psi1b1867zi8y8";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  configureFlags = [
    ( "--with-graphite2=" + (if withGraphite2 then "yes" else "no") ) # not auto-detected by default
    ( "--with-icu=" +       (if withIcu       then "yes" else "no") )
  ];

  nativeBuildInputs = [ pkgconfig libintl ];
  buildInputs = [ glib freetype cairo ]; # recommended by upstream
  propagatedBuildInputs = []
    ++ optional withGraphite2 graphite2
    ++ optionals withIcu [ icu harfbuzz ]
    ;

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
    platforms = with platforms; linux ++ darwin;
    inherit version;
    updateWalker = true;
  };
}
