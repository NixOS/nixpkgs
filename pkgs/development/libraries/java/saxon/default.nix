{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "saxon-6.5.3";
  builder = ./unzip-builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/saxon/saxon6_5_3.zip;
    sha256 = "0l5y3y2z4wqgh80f26dwwxwncs8v3nkz3nidv14z024lmk730vs3";
  };

  nativeBuildInputs = [ unzip ];

  # still leaving in root as well, in case someone is relying on that
  preFixup = ''
    mkdir -p "$out/share/java"
    cp -s "$out"/*.jar "$out/share/java/"
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
