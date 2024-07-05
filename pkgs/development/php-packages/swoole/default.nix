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
  version = "5.1.2";
in
buildPecl {
  inherit version;
  pname = "swoole";

  src = fetchFromGitHub {
    owner = "swoole";
    repo = "swoole-src";
    rev = "v${version}";
    hash = "sha256-WTsntvauiooj081mOoFcK6CVpnCCR/cEQtJbsOIJ/wo=";
  };

  buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.isDarwin) [ valgrind ];

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
