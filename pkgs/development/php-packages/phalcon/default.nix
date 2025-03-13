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
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "phalcon";
    repo = "cphalcon";
    rev = "v${version}";
    hash = "sha256-S+y0HIAFAVpWfeH2yvbYzbCd1iSyae3x1syuLQL3Ago=";
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

  meta = with lib; {
    description = "Phalcon is a full stack PHP framework offering low resource consumption and high performance";
    license = licenses.bsd3;
    homepage = "https://phalcon.io";
    maintainers = teams.php.members ++ [ maintainers.krzaczek ];
    broken = lib.versionAtLeast php.version "8.4";
  };
}
