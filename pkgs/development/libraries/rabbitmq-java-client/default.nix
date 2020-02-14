{ fetchurl, stdenv, ant, jdk, jre, python, makeWrapper }:

stdenv.mkDerivation {
  name = "rabbitmq-java-client-3.3.4";

  src = fetchurl {
    url = "https://www.rabbitmq.com/releases/rabbitmq-java-client/v3.3.4/rabbitmq-java-client-3.3.4.tar.gz";
    sha256 = "03kspkgzzjsbq6f8yl2zj5m30qwgxv3l58hrbf6gcgxb5rpfk6sh";
  };

  buildInputs = [ ant jdk python makeWrapper ];

  buildPhase = "ant dist";

  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp build/lib/*.jar lib/*.jar $out/share/java

    # There is a script in the source archive, but ours is cleaner
    makeWrapper ${jre}/bin/java $out/bin/PerfTest \
      --add-flags "-Djava.awt.headless=true -cp $out/share/java/\* com.rabbitmq.examples.PerfTest"
  '';

  meta = with stdenv.lib; {
    description = "RabbitMQ Java client library which allows Java code to interface to AMQP servers";
    homepage = https://www.rabbitmq.com/java-client.html;
    license = with licenses; [ mpl11 gpl2 ];
    platforms = platforms.linux;
  };
}
