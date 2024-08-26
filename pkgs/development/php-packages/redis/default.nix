{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
  fetchpatch,
}:

let
  version = "6.0.2";
in
buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    hash = "sha256-Ie31zak6Rqxm2+jGXWg6KN4czHe9e+190jZRQ5VoB+M=";
  };

  patches = [
    # Fix build with PHP 8.4.
    (fetchpatch {
      url = "https://github.com/phpredis/phpredis/commit/a51215ce2b22bcd1f506780c35b6833471e0b8cb.patch";
      hash = "sha256-DoGPMyuI/IZdF+8jG5faoyG2aM+WDz0obH6S7HoOMX8=";
    })
  ];

  internalDeps = with php.extensions; [ session ];

  meta = with lib; {
    changelog = "https://github.com/phpredis/phpredis/releases/tag/${version}";
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = teams.php.members;
  };
}
