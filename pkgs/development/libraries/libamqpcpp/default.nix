{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "libamqpcpp";
  version = "4.1.6";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${version}";
    sha256 = "0cw1apj4qxfxpp0gz4my4656d5ijjj6s2y4rjahhj67h10qj4bd2";
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
