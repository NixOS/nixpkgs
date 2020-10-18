{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "libamqpcpp";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
    sha256 = "0993vlvpa3vwg7qb5vl3jcnqwb8dqqfrxg4gg8mz7icnhx57kj34";
  };

  buildInputs = [ openssl ];

  patches = [ ./libamqpcpp-darwin.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for communicating with a RabbitMQ server";
    homepage = "https://github.com/CopernicaMarketingSoftware/AMQP-CPP";
    license = licenses.asl20;
    maintainers = [ maintainers.mjp ];
    platforms = platforms.all;
  };
}
