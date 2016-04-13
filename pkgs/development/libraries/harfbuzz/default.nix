{ stdenv, fetchurl, pkgconfig, glib, freetype, cairo, libintlOrEmpty
, icu, graphite2, harfbuzz # The icu variant uses and propagates the non-icu one.
, withIcu ? false # recommended by upstream as default, but most don't needed and it's big
, withGraphite2 ? true # it is small and major distros do include it
}:

let
  version = "1.1.2";
  inherit (stdenv.lib) optional optionals optionalString;
in

stdenv.mkDerivation {
  name = "harfbuzz${optionalString withIcu "-icu"}-${version}";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${version}.tar.bz2";
    sha256 = "07s6z3hbrb4rdfgzmln169wxz4nm5y7qbr02ik5c7drxpn85fb2a";
  };

  outputs = [ "dev" "out" ];
  outputBin = "dev";

  configureFlags = [
    ( "--with-graphite2=" + (if withGraphite2 then "yes" else "no") ) # not auto-detected by default
    ( "--with-icu=" +       (if withIcu       then "yes" else "no") )
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib freetype cairo ] # recommended by upstream
    ++ libintlOrEmpty;
  propagatedBuildInputs = []
    ++ optional withGraphite2 graphite2
    ++ optionals withIcu [ icu harfbuzz ]
    ;

  # Slightly hacky; some pkgs expect them in a single directory.
  postInstall = optionalString withIcu ''
    rm "$out"/lib/libharfbuzz.* "$dev/lib/pkgconfig/harfbuzz.pc"
    ln -s {'${harfbuzz.out}',"$out"}/lib/libharfbuzz.la
    ln -s {'${harfbuzz.dev}',"$dev"}/lib/pkgconfig/harfbuzz.pc
  '';

  meta = with stdenv.lib; {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ maintainers.eelco ];
    platforms = with platforms; linux ++ darwin;
  };
}
