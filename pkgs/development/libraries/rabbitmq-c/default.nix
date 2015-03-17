{ stdenv, fetchFromGitHub, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  name = "rabbitmq-c-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    sha256 = "00264mvwwcibd36w9a3s3cv2x7pvz88al64q2maaw1kbd9mg1ky5";
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
