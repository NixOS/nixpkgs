{lib, stdenv, fetchurl, jre}:

stdenv.mkDerivation rec {
  pname = "aspectj";
  version = "1.9.7";
  builder = ./builder.sh;

  src = let
    versionSnakeCase = builtins.replaceStrings ["."] ["_"] version;
  in fetchurl {
    url = "https://github.com/eclipse/org.aspectj/releases/download/V${versionSnakeCase}/aspectj-${version}.jar";
    sha256 = "sha256-xrg88nLOcagaAsFSnnYChhlv6EKhdBqkJJTDzhUBvTo=";
  };

  inherit jre;
  buildInputs = [jre];

  meta = {
    homepage = "http://www.eclipse.org/aspectj/";
    description = "A seamless aspect-oriented extension to the Java programming language";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.unix;
    license = lib.licenses.epl10;
  };
}
