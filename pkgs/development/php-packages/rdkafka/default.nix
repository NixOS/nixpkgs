{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "rdkafka";

  version = "4.0.3";
  sha256 = "1g00p911raxcc7n2w9pzadxaggw5c564md6hjvqfs9ip550y5x16";

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
