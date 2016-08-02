{ stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  name = "rascal-0.6.2";

  src = fetchurl {
    url = "http://update.rascal-mpl.org/console/${name}.jar";
    sha256 = "1z4mwdbdc3r24haljnxng8znlfg2ihm9bf9zq8apd9a32ipcw4i6";
  };

  buildInputs = [ makeWrapper jdk ];

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out/bin
      makeWrapper ${jdk}/bin/java $out/bin/rascal \
        --add-flags "-jar ${src}" \
    '';

  meta = {
    homepage = http://www.rascal-mpl.org/;
    description = "Command-line REPL for the Rascal metaprogramming language";
    license = stdenv.lib.licenses.epl10;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
