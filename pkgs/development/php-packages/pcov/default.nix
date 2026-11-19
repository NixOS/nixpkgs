{
  buildPecl,
  lib,
  php,
  pcre2,
  fetchFromGitHub,
}:

buildPecl (finalAttrs: {
  pname = "pcov";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "pcov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yz+c1FrjGJAUgnu+azvebqoAN3I/GXLeAlKobNdDiHI=";
  };

  buildInputs = [ pcre2 ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/krakjoe/pcov/releases/tag/v${finalAttrs.version}";
    description = "Self contained php-code-coverage compatible driver for PHP";
    license = lib.licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    teams = [ lib.teams.php ];
  };
})
