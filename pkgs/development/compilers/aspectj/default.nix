{lib, stdenv, fetchurl, jre}:

stdenv.mkDerivation rec {
  pname = "aspectj";
  version = "1.9.6";
  builder = ./builder.sh;

  src = let
    versionSnakeCase = builtins.replaceStrings ["."] ["_"] version;
  in fetchurl {
    url = "https://github.com/eclipse/org.aspectj/releases/download/V${versionSnakeCase}/aspectj-${version}.jar";
    sha256 = "02jh66l3vw57k9a4dxlga3qh3487r36gyi6k2z2mmqxbpqajslja";
  };

  inherit jre;
  buildInputs = [jre];

  meta = {
    homepage = "http://www.eclipse.org/aspectj/";
    description = "A seamless aspect-oriented extension to the Java programming language";
    platforms = lib.platforms.unix;
    license = lib.licenses.epl10;
  };
}
