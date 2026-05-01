{
  buildPecl,
  lib,
  rabbitmq-c,
  fetchFromGitHub,
}:

let
  version = "2.2.0";
in
buildPecl {
  inherit version;
  pname = "amqp";

  src = fetchFromGitHub {
    owner = "php-amqp";
    repo = "php-amqp";
    rev = "v${version}";
    sha256 = "sha256-HgwuQWxJFno24yo26qM30Qb8s3L9mYVntvMxC2MYxTk=";
  };

  buildInputs = [ rabbitmq-c ];

  AMQP_DIR = rabbitmq-c;

  meta = {
    changelog = "https://github.com/php-amqp/php-amqp/releases/tag/v${version}";
    description = "PHP extension to communicate with any AMQP compliant server";
    license = lib.licenses.php301;
    homepage = "https://github.com/php-amqp/php-amqp";
    teams = [ lib.teams.php ];
  };
}
