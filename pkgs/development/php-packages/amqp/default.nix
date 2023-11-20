{ buildPecl, lib, rabbitmq-c, fetchFromGitHub }:

let
  version = "2.1.1";
in buildPecl {
  inherit version;
  pname = "amqp";

  src = fetchFromGitHub {
    owner = "php-amqp";
    repo = "php-amqp";
    rev = "v${version}";
    sha256 = "sha256-QHiQL3INd0zQpmCOcJx7HhN770m9ql0Cs63OTOLOrNQ=";
  };

  buildInputs = [ rabbitmq-c ];

  AMQP_DIR = rabbitmq-c;

  meta = with lib; {
    changelog = "https://github.com/php-amqp/php-amqp/releases/tag/v${version}";
    description = "PHP extension to communicate with any AMQP compliant server";
    license = licenses.php301;
    homepage = "https://github.com/php-amqp/php-amqp";
    maintainers = teams.php.members;
  };
}
