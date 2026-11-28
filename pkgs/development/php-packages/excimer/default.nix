{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
}:

buildPecl (finalAttrs: {
  version = "1.2.6";
  pname = "excimer";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-excimer";
    tag = finalAttrs.version;
    hash = "sha256-LnmhItq7OpxXXE6EnTOXZVdfo+MTa2Ud9j16rs8dTBo=";
  };

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://pecl.php.net/package-changelog.php?package=excimer&release=${finalAttrs.version}";
    description = "PHP extension that provides an interrupting timer and a low-overhead sampling profiler";
    license = lib.licenses.asl20;
    homepage = "https://mediawiki.org/wiki/Excimer";
    teams = [ lib.teams.php ];
  };
})
