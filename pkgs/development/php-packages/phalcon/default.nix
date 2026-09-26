{
  buildPecl,
  lib,
  pcre2,
  fetchFromGitHub,
  php,
  pkg-config,
}:

buildPecl rec {
  pname = "phalcon";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "phalcon";
    repo = "cphalcon";
    rev = "v${version}";
    hash = "sha256-2dk/AjOWG2oJ3BoBODO9H4S32Jc/Z+W3qxvMkfR5oKE=";
  };

  internalDeps = [
    php.extensions.session
    php.extensions.pdo
  ];

  # Fix GCC 14 build.
  # from incompatible pointer type [-Wincompatible-pointer-types]
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre2 ];

  sourceRoot = "${src.name}/build/phalcon";

  meta = {
    description = "Phalcon is a full stack PHP framework offering low resource consumption and high performance";
    license = lib.licenses.bsd3;
    homepage = "https://phalcon.io";
    maintainers = [ lib.maintainers.krzaczek ];
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.5";
  };
}
