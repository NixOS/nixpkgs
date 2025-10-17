{
  buildPecl,
  lib,
  fetchFromGitHub,
  zlib,
}:

let
  version = "0.4.21";
in
buildPecl {
  inherit version;
  pname = "spx";

  src = fetchFromGitHub {
    owner = "NoiseByNorthwest";
    repo = "php-spx";
    rev = "v${version}";
    hash = "sha256-3rVnKUZZXLxoKCW717pCiPOVWDudQpoN8lC1jQzpwuw=";
  };

  configureFlags = [
    "--with-zlib-dir=${zlib.dev}"
    "--with-spx-assets-dir=${placeholder "out"}/share/misc/php-spx/assets/"
  ];

  meta = {
    changelog = "https://github.com/NoiseByNorthwest/php-spx/releases/tag/${version}";
    description = "Simple & straight-to-the-point PHP profiling extension with its built-in web UI";
    homepage = "https://github.com/NoiseByNorthwest/php-spx";
    license = lib.licenses.php301;
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
}
