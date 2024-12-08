{
  buildPecl,
  lib,
  rdkafka,
  pcre2,
}:

buildPecl {
  pname = "rdkafka";

  version = "6.0.3";
  sha256 = "sha256-Euqrl21JaX4x8WOLR4ietexhrbdYcIlBESsVf47H3Ug=";

  buildInputs = [
    rdkafka
    pcre2
  ];

  postPhpize = ''
    substituteInPlace configure \
      --replace 'SEARCH_PATH="/usr/local /usr"' 'SEARCH_PATH=${rdkafka}'
  '';

  meta = with lib; {
    description = "Kafka client based on librdkafka";
    license = licenses.mit;
    homepage = "https://github.com/arnaud-lb/php-rdkafka";
    maintainers = teams.php.members;
  };
}
