{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  popt,
  xmlto,
}:

stdenv.mkDerivation rec {
  pname = "rabbitmq-c";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    hash = "sha256-ffdnLEgUg+4G12JntjFag3ZXMvEL42hsrY6VT58ccJ0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    popt
    xmlto
  ];

  meta = with lib; {
    description = "RabbitMQ C AMQP client library";
    homepage = "https://github.com/alanxz/rabbitmq-c";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
