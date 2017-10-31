{ stdenv, fetchFromGitHub, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  name = "rabbitmq-c-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    sha256 = "084zlir59zc505nxd4m2g9d355m9a8y94gbjaqmjz9kym8lpayd1";
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
