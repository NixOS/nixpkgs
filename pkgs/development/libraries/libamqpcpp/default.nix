{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "libamqpcpp";
  version = "4.1.7";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
    sha256 = "16xgl0yqzqkqfrz7x9rbbv8rj5rg5jlz4a7apj9igqb58q0w362x";
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
