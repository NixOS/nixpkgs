{ buildPecl, lib, php, fetchFromGitHub }:

let
  version = "5.3.7";
in buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    sha256 = "sha256-Cc9Mtx28j3kpyV8Yq+JSYQt5XQnELaVjuUbkkbG45kw=";
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
