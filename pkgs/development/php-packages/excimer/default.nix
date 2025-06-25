{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "1.2.5";
in
buildPecl {
  inherit version;
  pname = "excimer";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-excimer";
    tag = version;
    hash = "sha256-xFnyqofazXtPfwp/4xNYwrPEW9vWzz5akXjCOiyP4nw=";
  };

  meta = {
    changelog = "https://pecl.php.net/package-changelog.php?package=excimer&release=${version}";
    description = "PHP extension that provides an interrupting timer and a low-overhead sampling profiler";
    license = lib.licenses.asl20;
    homepage = "https://mediawiki.org/wiki/Excimer";
    teams = [ lib.teams.php ];
  };
}
