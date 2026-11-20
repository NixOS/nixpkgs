{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
}:

buildPecl (finalAttrs: {
  pname = "xdebug";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    tag = finalAttrs.version;
    hash = "sha256-UrRQqnWEE0y8I4DTDWn21yGScG42+XaFFl6UjcJXbtM=";
  };

  doCheck = true;

  zendExtension = true;

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${finalAttrs.version}";
    description = "Provides functions for function traces and profiling";
    homepage = "https://xdebug.org/";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
})
