{ stdenv, fetchFromGitHub, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  name = "rabbitmq-c-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    sha256 = "0vjh1q3hyzrq1iiddy28vvwpwwn4px00mjc2hqp4zgfpis2xlqbj";
  };

  buildInputs = [ cmake openssl popt xmlto ];

  meta = with stdenv.lib; {
    description = "RabbitMQ C AMQP client library";
    homepage = https://github.com/alanxz/rabbitmq-c;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
