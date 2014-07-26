{ fetchurl, stdenv, ant, jdk, python }:

stdenv.mkDerivation rec {
  name = "rabbitmq-java-client-3.3.4";

  src = fetchurl {
    url = "http://www.rabbitmq.com/releases/rabbitmq-java-client/v3.3.4/rabbitmq-java-client-3.3.4.tar.gz";
    sha256 = "03kspkgzzjsbq6f8yl2zj5m30qwgxv3l58hrbf6gcgxb5rpfk6sh";
  };

  buildInputs = [ ant jdk python ];

  buildPhase = "ant dist";

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp build/lib/*.jar lib/*.jar $out/lib/

    # There is a script in the source archive, but ours is cleaner
    cat > "$out/bin/PerfTest" <<EOF
    #!${stdenv.shell}
    java_exec_args="-Djava.awt.headless=true"
    exec ${jdk.jre}/bin/java \$java_exec_args -classpath "$out/lib/*" com.rabbitmq.examples.PerfTest "\$@"
    EOF
    chmod a+x $out/bin/PerfTest
  '';

  meta = with stdenv.lib; {
    description = "RabbitMQ Java client library which allows Java code to interface to AMQP servers";
    homepage = http://www.rabbitmq.com/java-client.html;
    license = [ "MPLv1.1" "GPLv2" ];
    platforms = platforms.linux;
  };
}
