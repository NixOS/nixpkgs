{
  aspell,
  buildPecl,
  fetchFromGitHub,
  lib,
}:

let
  version = "1.0.1";
in
buildPecl {
  inherit version;
  pname = "pspell";

  src = fetchFromGitHub {
    owner = "php";
    repo = "pecl-text-pspell";
    rev = version;
    hash = "sha256-IVBuEVsUKah8W+oVpIPT9Iln6MFox0e5/5Y14/Kgcg4=";
  };

  configureFlags = [ "--with-pspell=${aspell}" ];

  doCheck = true;

  meta = {
    description = "PHP extension for checking the spelling of a word";
    homepage = "https://pecl.php.net/package/pspell";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
}
