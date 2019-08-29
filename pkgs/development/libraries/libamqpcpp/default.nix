{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "libamqpcpp-${version}";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
    sha256 = "0qk431ra7vcklc67fdaddrj5a7j50znjr79zrwvhkcfy82fd56zw";
  };

  buildInputs = [ openssl ];

  patches = [ ./libamqpcpp-darwin.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for communicating with a RabbitMQ server";
    homepage = https://github.com/CopernicaMarketingSoftware/AMQP-CPP;
    license = licenses.asl20;
    maintainers = [ maintainers.mjp ];
    platforms = platforms.all;
  };
}
