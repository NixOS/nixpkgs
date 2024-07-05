{ fetchurl, lib, stdenv, ant, jdk, jre, python2, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rabbitmq-java-client";
  version = "3.3.4";

  src = fetchurl {
    url = "https://www.rabbitmq.com/releases/rabbitmq-java-client/v${version}/rabbitmq-java-client-${version}.tar.gz";
    sha256 = "03kspkgzzjsbq6f8yl2zj5m30qwgxv3l58hrbf6gcgxb5rpfk6sh";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ant jdk python2 ];

  buildPhase = "ant dist";

  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp build/lib/*.jar lib/*.jar $out/share/java

    # There is a script in the source archive, but ours is cleaner
    makeWrapper ${jre}/bin/java $out/bin/PerfTest \
      --add-flags "-Djava.awt.headless=true -cp $out/share/java/\* com.rabbitmq.examples.PerfTest"
  '';

  meta = with lib; {
    description = "RabbitMQ Java client library which allows Java code to interface to AMQP servers";
    homepage = "https://www.rabbitmq.com/java-client.html";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
    ];
    license = with licenses; [ mpl11 gpl2 ];
    platforms = platforms.linux;
  };
}
