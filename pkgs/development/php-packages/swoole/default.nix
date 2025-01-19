{
  lib,
  stdenv,
  buildPecl,
  php,
  valgrind,
  pcre2,
  fetchFromGitHub,
}:

let
  version = "6.0.0";
in
buildPecl {
  inherit version;
  pname = "swoole";

  src = fetchFromGitHub {
    owner = "swoole";
    repo = "swoole-src";
    rev = "v${version}";
    hash = "sha256-h49TMwtEaaRfQO69Z9sAPsCqLYt/w/6Vx9ZVBajAU5U=";
  };

  buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ valgrind ];

  # tests require internet access
  doCheck = false;

  meta = {
    changelog = "https://github.com/swoole/swoole-src/releases/tag/v${version}";
    description = "Coroutine-based concurrency library for PHP";
    homepage = "https://www.swoole.com";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
  };
}
