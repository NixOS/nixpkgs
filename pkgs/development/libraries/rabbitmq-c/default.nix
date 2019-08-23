{ stdenv, fetchFromGitHub, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  name = "rabbitmq-c-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    sha256 = "1mhzxyh9pmpxjjbyy8hd34gm39sxf73r1ldk8zjfsfbs26ggrppz";
  };

  buildInputs = [ cmake openssl popt xmlto ];

  meta = with stdenv.lib; {
    description = "RabbitMQ C AMQP client library";
    homepage = https://github.com/alanxz/rabbitmq-c;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
