{ lib, stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "rascal";
  version = "0.28.2";

  src = fetchurl {
    url = "https://update.rascal-mpl.org/console/${pname}-${version}.jar";
    sha256 = "sha256-KMoGTegjXuGSzNnwH6SkcM5GC/F3oluvFrlJ51Pms3M=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk ];

  dontUnpack = true;

  installPhase =
    ''
      mkdir -p $out/bin
      makeWrapper ${jdk}/bin/java $out/bin/rascal \
        --add-flags "-jar ${src}" \
    '';

  meta = {
    homepage = "https://www.rascal-mpl.org/";
    description = "Command-line REPL for the Rascal metaprogramming language";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.unix;
  };
}
