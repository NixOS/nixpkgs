{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "libamqpcpp-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
    sha256 = "0n93wy2v2hx9zalpyn8zxsxihh0xpgcd472qwvwsc253y97v8ngv";
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
