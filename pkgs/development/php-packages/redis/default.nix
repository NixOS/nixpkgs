{ buildPecl, lib, php, fetchFromGitHub }:

buildPecl rec {
  pname = "redis";
  version = "5.3.7";

  src = fetchFromGitHub {
    owner = "phpredis";
    repo = "phpredis";
    rev = version;
    sha256 = "sha256-Cc9Mtx28j3kpyV8Yq+JSYQt5XQnELaVjuUbkkbG45kw=";
  };

  internalDeps = with php.extensions; [
    session
  ] ++ lib.optionals (lib.versionOlder php.version "8.0") [
    json
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    hash
  ];

  meta = with lib; {
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = teams.php.members;
  };
}
