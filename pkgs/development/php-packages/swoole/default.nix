{
  lib,
  stdenv,
  buildPecl,
  php,
  valgrind,
  pcre2,
  openssl,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "6.2.3";
in
buildPecl {
  inherit version;
  pname = "swoole";

  src = fetchFromGitHub {
    owner = "swoole";
    repo = "swoole-src";
    tag = "v${version}";
    hash = "sha256-VAtFR90bnS0ipta/BSOmmcEGTB+rzIQ83hm4lmrPJVI=";
  };

  # sw_usleep is undefined in the non-futex (Darwin) path
  # https://github.com/swoole/swoole-src/issues/6243
  postPatch = ''
    substituteInPlace src/core/misc.cc \
      --replace-fail "sw_usleep(1000);" "usleep(1000);"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    pcre2
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ valgrind ];

  # tests require internet access
  doCheck = false;

  meta = {
    changelog = "https://github.com/swoole/swoole-src/releases/tag/v${version}";
    description = "Coroutine-based concurrency library for PHP";
    homepage = "https://www.swoole.com";
    license = lib.licenses.asl20;
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.5";
  };
}
