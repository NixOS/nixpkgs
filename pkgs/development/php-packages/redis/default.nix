{ buildPecl, lib, php, fetchFromGitHub }:

let
  version = "6.0.2";
in buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    hash = "sha256-Ie31zak6Rqxm2+jGXWg6KN4czHe9e+190jZRQ5VoB+M=";
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
