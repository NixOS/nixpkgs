{
  buildPecl,
  lib,
  rdkafka,
  pcre2,
}:

buildPecl {
  pname = "rdkafka";
  version = "6.0.4";
  hash = "sha256-DZc5YxOjFnruSZqVFtqFzKJa+Y5fS1XaxVVBAJvzWlk=";

  buildInputs = [
    rdkafka
    pcre2
  ];

  postPhpize = ''
    substituteInPlace configure \
      --replace-fail 'SEARCH_PATH="/usr/local /usr"' 'SEARCH_PATH=${lib.getInclude rdkafka}'
  '';

  meta = {
    description = "Kafka client based on librdkafka";
    license = lib.licenses.mit;
    homepage = "https://github.com/arnaud-lb/php-rdkafka";
    teams = [ lib.teams.php ];
  };
}
