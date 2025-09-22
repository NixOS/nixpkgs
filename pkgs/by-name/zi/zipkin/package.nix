{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenv.mkDerivation rec {
  version = "1.28.1";
  pname = "zipkin-server";
  src = fetchurl {
    url = "https://search.maven.org/remotecontent?filepath=io/zipkin/java/zipkin-server/${version}/zipkin-server-${version}-exec.jar";
    sha256 = "02369fkv0kbl1isq6y26fh2zj5wxv3zck522m5wypsjlcfcw2apa";
  };
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/share/java
    cp ${src} $out/share/java/zipkin-server-${version}-exec.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/zipkin-server \
      --add-flags "-cp $out/share/java/zipkin-server-${version}-exec.jar org.springframework.boot.loader.JarLauncher"
  '';
  meta = with lib; {
    description = "Distributed tracing system";
    homepage = "https://zipkin.io/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.hectorj ];
    mainProgram = "zipkin-server";
  };
}
