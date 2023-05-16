{ buildPecl, lib }:

buildPecl rec {
<<<<<<< HEAD
  version = "2.2.0";
  pname = "msgpack";

  sha256 = "sha256-gqoeQExf9U7EHSogEwXNZZTtFKdSnpEZ+nykV+S70So=";

  meta = {
    changelog = "https://pecl.php.net/package-info.php?package=msgpack&version=${version}";
    description = "PHP extension for interfacing with MessagePack";
    homepage = "https://github.com/msgpack/msgpack-php";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.ostrolucky ];
=======
  version = "2.2.0RC2";
  pname = "msgpack";

  sha256 = "sha256-bVV043knbk7rionXqB70RKa1zlJ5K/Nw0oTXZllmJOg=";

  meta = with lib; {
    changelog = "https://pecl.php.net/package-info.php?package=msgpack&version=${version}";
    description = "PHP extension for interfacing with MessagePack";
    license = licenses.bsd3;
    homepage = "https://github.com/msgpack/msgpack-php";
    maintainers = teams.php.members ++ [ maintainers.ostrolucky ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
