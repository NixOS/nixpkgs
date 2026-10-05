{
  buildPecl,
  lib,
  fetchFromGitHub,
  libuv,
}:

buildPecl rec {
  pname = "uv";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "amphp";
    repo = "ext-uv";
    tag = "v${version}";
    hash = "sha256-CM81dStUgQpLIb7s6jlWkP3v4WyyxjZ+3EX80tdSPc0=";
  };

  buildInputs = [ libuv ];

  meta = {
    description = "Interface to libuv for php";
    license = lib.licenses.php301;
    homepage = "https://github.com/amphp/ext-uv";
    teams = [ lib.teams.php ];
    platforms = lib.platforms.linux;
  };
}
