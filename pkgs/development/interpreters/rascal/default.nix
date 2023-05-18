{ lib, stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "rascal";
  version = "0.6.2";

  src = fetchurl {
    url = "https://update.rascal-mpl.org/console/${pname}-${version}.jar";
    sha256 = "1z4mwdbdc3r24haljnxng8znlfg2ihm9bf9zq8apd9a32ipcw4i6";
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
