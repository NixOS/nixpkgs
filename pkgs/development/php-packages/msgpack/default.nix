{ buildPecl, lib }:

buildPecl rec {
  version = "2.2.0RC2";
  pname = "msgpack";

  sha256 = "sha256-bVV043knbk7rionXqB70RKa1zlJ5K/Nw0oTXZllmJOg=";

  meta = with lib; {
    changelog = "https://pecl.php.net/package-info.php?package=msgpack&version=${version}";
    description = "PHP extension for interfacing with MessagePack";
    license = licenses.bsd3;
    homepage = "https://github.com/msgpack/msgpack-php";
    maintainers = teams.php.members ++ [ maintainers.ostrolucky ];
  };
}
