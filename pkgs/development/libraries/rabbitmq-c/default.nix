{ stdenv, fetchurl, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  version = "0.4.1";
  name = "rabbitmq-c-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/alanxz/rabbitmq-c/releases/download/v${version}/${name}.tar.gz";
    sha256 = "01m4n043hzhhxky8z67zj3r4gbg3mwcqbwqr9nms9lqbfaa70x93";
  };

  buildInputs = [ cmake openssl popt xmlto ];

  meta = {
    description = "RabbitMQ C AMQP client library";
    homepage = https://github.com/alanxz/rabbitmq-c;
    license = with stdenv.lib.licenses; mit;
    platforms = with stdenv.lib.platforms; linux;
  };
}
