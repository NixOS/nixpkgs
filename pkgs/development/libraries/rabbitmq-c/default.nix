{ stdenv, fetchFromGitHub, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  name = "rabbitmq-c-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    sha256 = "1nfb82lbccr46wr4a2fsrkvpvdvmnyx8kn275hvdfz7mxpkd5qy6";
  };

  buildInputs = [ cmake openssl popt xmlto ];

  meta = with stdenv.lib; {
    description = "RabbitMQ C AMQP client library";
    homepage = https://github.com/alanxz/rabbitmq-c;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
