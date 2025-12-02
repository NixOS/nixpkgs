{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  # TODO: switch to jre https://github.com/NixOS/nixpkgs/pull/89731
  jre8,
}:

stdenv.mkDerivation rec {
  pname = "tlaplus";
  version = "1.7.4";

  src = fetchurl {
    url = "https://github.com/tlaplus/tlaplus/releases/download/v${version}/tla2tools.jar";
    sha256 = "sha256-k2omIGHJFGlN/WaaVDviRXPEXVqg/yCouWsj0B4FDog=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/tla2tools.jar

    makeWrapper ${jre8}/bin/java $out/bin/tlc \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tlc2.TLC"
    makeWrapper ${jre8}/bin/java $out/bin/tlasany \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tla2sany.SANY"
    makeWrapper ${jre8}/bin/java $out/bin/pcal \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar pcal.trans"
    makeWrapper ${jre8}/bin/java $out/bin/tlatex \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tla2tex.TLA"
  '';

  meta = {
    description = "Algorithm specification language with model checking tools";
    homepage = "https://lamport.azurewebsites.net/tla/tla.html";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      florentc
      thoughtpolice
      mgregson
    ];
  };
}
