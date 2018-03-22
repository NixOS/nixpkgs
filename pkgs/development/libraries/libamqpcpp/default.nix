{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libamqpcpp-${version}";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
    sha256 = "0m010bz0axawcpv4d1p1vx7c6r8lg27w2s2vjqpbpg99w35n6c8k";
  };

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
