{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "rdkafka";

  version = "4.1.1";
  sha256 = "0s6cqd71z5jpqb98myk4askmbqphzzslf0d4vqlg2rig9q6fyv7x";

  buildInputs = [ pkgs.rdkafka pcre' ];

  postPhpize = ''
    substituteInPlace configure \
      --replace 'SEARCH_PATH="/usr/local /usr"' 'SEARCH_PATH=${pkgs.rdkafka}'
  '';

  meta = with lib; {
    description = "Kafka client based on librdkafka";
    homepage = "https://github.com/arnaud-lb/php-rdkafka";
    maintainers = teams.php.members;
  };
}
