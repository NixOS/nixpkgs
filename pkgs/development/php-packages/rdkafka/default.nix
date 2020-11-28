{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "rdkafka";

  version = "4.0.4";
  sha256 = "18a8p43i2g93fv7qzvk2hk66z5iv0mk1rqn097x49bjigliv60mn";

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
