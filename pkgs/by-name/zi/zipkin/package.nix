{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.28.1";
  pname = "zipkin-server";
  src = fetchurl {
    url = "https://search.maven.org/remotecontent?filepath=io/zipkin/java/zipkin-server/${finalAttrs.version}/zipkin-server-${finalAttrs.version}-exec.jar";
    sha256 = "02369fkv0kbl1isq6y26fh2zj5wxv3zck522m5wypsjlcfcw2apa";
  };
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/share/java
    cp ${finalAttrs.src} $out/share/java/zipkin-server-${finalAttrs.version}-exec.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/zipkin-server \
      --add-flags "-cp $out/share/java/zipkin-server-${finalAttrs.version}-exec.jar org.springframework.boot.loader.JarLauncher"
  '';
  meta = {
    description = "Distributed tracing system";
    homepage = "https://zipkin.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.hectorj ];
    mainProgram = "zipkin-server";
  };
})
