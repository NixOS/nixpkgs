{ buildPecl, lib, php, fetchFromGitHub }:

let
  version = "6.0.1";
in buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    hash = "sha256-0by0TC4TNFIzgMjoyuJG4EavMhkYqmn8TtRaVmgepfc=";
  };

  internalDeps = with php.extensions; [
    session
  ];

  meta = with lib; {
    changelog = "https://github.com/phpredis/phpredis/releases/tag/${version}";
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = teams.php.members;
  };
}
