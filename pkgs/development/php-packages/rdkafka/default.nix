{ buildPecl, lib, rdkafka, pcre2 }:

buildPecl {
  pname = "rdkafka";

  version = "5.0.2";
  sha256 = "sha256-slCwtt8ySE5Zk2tnaYO6E0N20VZS8CVSsr8EgqssvOk=";

  buildInputs = [ rdkafka pcre2 ];

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
