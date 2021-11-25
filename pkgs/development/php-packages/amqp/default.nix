{ buildPecl, lib, rabbitmq-c }:

buildPecl {
  pname = "amqp";

  version = "1.11.0beta";
  sha256 = "sha256-HbVLN6fg2htYZgAFw+IhYHP+XN8j7cTLG6S0YHHOC14=";

  buildInputs = [ rabbitmq-c ];

  AMQP_DIR = rabbitmq-c;

  meta = with lib; {
    description = "PHP extension to communicate with any AMQP compliant server";
    license = licenses.php301;
    homepage = "https://github.com/php-amqp/php-amqp";
    maintainers = teams.php.members;
  };
}
