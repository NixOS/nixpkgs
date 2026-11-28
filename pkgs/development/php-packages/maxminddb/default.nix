{
  buildPecl,
  lib,
  fetchFromGitHub,
  libmaxminddb,
}:

buildPecl (finalAttrs: {
  pname = "maxminddb";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "MaxMind-DB-Reader-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JkdtBKpxxaynAlQ9g0/unQ4w1RbLFuR8c6qQyOZV2Rg=";
  };

  prePatch = ''
    cd ext
  '';

  buildInputs = [ libmaxminddb ];

  meta = {
    description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
    license = lib.licenses.asl20;
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-php";
    maintainers = with lib.maintainers; [ helsinki-Jo ];
    teams = [ lib.teams.php ];
  };
})
