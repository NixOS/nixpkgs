{
  buildPecl,
  lib,
  rdkafka,
  pcre2,
}:

buildPecl {
  pname = "rdkafka";
  version = "6.0.5";
  hash = "sha256-Cva2ZcljyMfREJzsc4A0N42ciGPL9hLAvTI15RmnCPE=";

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
