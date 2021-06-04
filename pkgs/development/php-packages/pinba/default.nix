{ buildPecl, lib, fetchFromGitHub, php }:

buildPecl {
  pname = "pinba";
  version = "1.1.2-dev";

  src = fetchFromGitHub {
    owner = "tony2001";
    repo = "pinba_extension";
    rev = "edbc313f1b4fb8407bf7d5acf63fbb0359c7fb2e";
    sha256 = "02sljqm6griw8ccqavl23f7w1hp2zflcv24lpf00k6pyrn9cwx80";
  };

  meta = with lib; {
    description = "PHP extension for Pinba";
    longDescription = ''
      Pinba is a MySQL storage engine that acts as a realtime monitoring and
      statistics server for PHP using MySQL as a read-only interface.
    '';
    homepage = "http://pinba.org/";
    maintainers = teams.php.members;
  };
}
