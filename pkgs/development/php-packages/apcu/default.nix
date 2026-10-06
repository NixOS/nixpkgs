{
  buildPecl,
  lib,
  pcre2,
  fetchFromGitHub,
  fetchpatch,
}:

let
  version = "5.1.28";
in
buildPecl {
  inherit version;
  pname = "apcu";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    rev = "v${version}";
    sha256 = "sha256-L8bGSPUuBsZXsJdeY6cVA0DvI2+0wEbNHH6IcfT+cFU=";
  };

  # PHP 8.6 compatibility, backported from upstream master
  patches = [
    (fetchpatch {
      name = "php86-empty-switch-default-case.patch";
      url = "https://github.com/krakjoe/apcu/commit/d29e907791502af89a7996930f8dce5fd8efe4a1.patch";
      excludes = [ ".github/*" ];
      hash = "sha256-Xd6v7MZ9/Ur2lQHS2xCjcgskenNCWmXhoH+2v/7O1bw=";
    })
    (fetchpatch {
      name = "php86-xtoffsetof.patch";
      url = "https://github.com/krakjoe/apcu/commit/95f9ab828f95c6ca5877e584ead109189d0cec61.patch";
      hash = "sha256-hED/qZayZJ3NVM5e/eDtrKtykMEhxjmWgI++T+oTL1c=";
    })
    (fetchpatch {
      name = "php86-php-verror.patch";
      url = "https://github.com/krakjoe/apcu/commit/90899684be91c4f750512c2f840f487286ecb807.patch";
      hash = "sha256-uSOZP6Qlw3WylqJI34yFP3l8z0nsIL1bHhfEyJmIimw=";
    })
  ];

  buildInputs = [ pcre2 ];
  doCheck = true;
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [
    "out"
    "dev"
  ];

  meta = {
    changelog = "https://github.com/krakjoe/apcu/releases/tag/v${version}";
    description = "Userland cache for PHP";
    homepage = "https://pecl.php.net/package/APCu";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
}
