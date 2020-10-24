{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "2.9.8";
  sha256 = "12igfrdfisqfmfqpc321g93pm2w1y7h24bclmxjrjv6rb36bcmgm";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta.maintainers = lib.teams.php.members;
}
