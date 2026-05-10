{
  buildPecl,
  lib,
  pcre2,
  fetchFromGitHub,
  fetchpatch,
}:

let
  version = "1.0.12";
in
buildPecl {
  inherit version;
  pname = "pcov";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "pcov";
    tag = "v${version}";
    hash = "sha256-yz+c1FrjGJAUgnu+azvebqoAN3I/GXLeAlKobNdDiHI=";
  };

  buildInputs = [ pcre2 ];

  meta = {
    changelog = "https://github.com/krakjoe/pcov/releases/tag/v${version}";
    description = "Self contained php-code-coverage compatible driver for PHP";
    license = lib.licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    teams = [ lib.teams.php ];
  };
}
