{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "1.2.3";
in
buildPecl {
  inherit version;
  pname = "excimer";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-excimer";
    tag = version;
    hash = "sha256-p1tnrrSiTtoin/QSQFeeiX0Di1wFD8CMTdLazOfjWKU=";
  };

  meta = {
    changelog = "https://pecl.php.net/package-changelog.php?package=excimer&release=${version}";
    description = "PHP extension that provides an interrupting timer and a low-overhead sampling profiler";
    license = lib.licenses.asl20;
    homepage = "https://mediawiki.org/wiki/Excimer";
    maintainers = lib.teams.php.members;
  };
}
