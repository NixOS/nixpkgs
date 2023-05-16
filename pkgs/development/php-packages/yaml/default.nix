{ buildPecl, lib, pkg-config, libyaml }:

buildPecl {
  pname = "yaml";

<<<<<<< HEAD
  version = "2.2.3";
  sha256 = "sha256-WTfrlyLd9tZGJnmc+gJFmP8kUuoVeZLk5nMxolP5AjY=";

  configureFlags = [ "--with-yaml=${libyaml.dev}" ];

  nativeBuildInputs = [ pkg-config libyaml ];

  meta = {
    description = "YAML-1.1 parser and emitter";
    license = lib.licenses.mit;
    homepage = "https://github.com/php/pecl-file_formats-yaml";
    maintainers = lib.teams.php.members;
=======
  version = "2.2.2";
  sha256 = "sha256-EZBS8EYdV9hvRMJS+cmy3XQ0hscBwaCroK6+zdDYuCo=";

  configureFlags = [ "--with-yaml=${libyaml}" ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "YAML-1.1 parser and emitter";
    license = licenses.mit;
    homepage = "https://bd808.com/pecl-file_formats-yaml/";
    maintainers = teams.php.members;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
