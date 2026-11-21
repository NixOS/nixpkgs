{
  buildPecl,
  lib,
  php,
}:

buildPecl (finalAttrs: {
  pname = "msgpack";
  version = "3.0.1";

  sha256 = "sha256-4wvjVat5qupFaGkvvWBz/Xx/UOqNPPEu3OQPwMkh2Gg=";

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://pecl.php.net/package-info.php?package=msgpack&version=${finalAttrs.version}";
    description = "PHP extension for interfacing with MessagePack";
    homepage = "https://github.com/msgpack/msgpack-php";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ostrolucky ];
    teams = [ lib.teams.php ];
  };
})
