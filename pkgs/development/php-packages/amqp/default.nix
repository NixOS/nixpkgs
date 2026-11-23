{
  buildPecl,
  lib,
  php,
  rabbitmq-c,
  fetchFromGitHub,
}:

buildPecl (finalAttrs: {
  pname = "amqp";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "php-amqp";
    repo = "php-amqp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HgwuQWxJFno24yo26qM30Qb8s3L9mYVntvMxC2MYxTk=";
  };

  buildInputs = [ rabbitmq-c ];

  env.AMQP_DIR = rabbitmq-c;

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/php-amqp/php-amqp/releases/tag/v${finalAttrs.version}";
    description = "PHP extension to communicate with any AMQP compliant server";
    license = lib.licenses.php301;
    homepage = "https://github.com/php-amqp/php-amqp";
    teams = [ lib.teams.php ];
  };
})
