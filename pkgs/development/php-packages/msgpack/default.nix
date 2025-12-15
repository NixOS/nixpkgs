{ buildPecl, lib }:

buildPecl rec {
  version = "3.0.0";
  pname = "msgpack";

  sha256 = "sha256-VTBqhHl9OZxrJpGB7EhGNPGL6hMwu9nXQFBDxZfeac0=";

  meta = {
    changelog = "https://pecl.php.net/package-info.php?package=msgpack&version=${version}";
    description = "PHP extension for interfacing with MessagePack";
    homepage = "https://github.com/msgpack/msgpack-php";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ostrolucky ];
    teams = [ lib.teams.php ];
  };
}
