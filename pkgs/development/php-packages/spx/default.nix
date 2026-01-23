{
  buildPecl,
  lib,
  fetchFromGitHub,
  zlib,
}:

let
  version = "0.4.22";
in
buildPecl {
  inherit version;
  pname = "spx";

  src = fetchFromGitHub {
    owner = "NoiseByNorthwest";
    repo = "php-spx";
    rev = "v${version}";
    hash = "sha256-P53g/o4i+QETWdErZaGA3AREvnr8kL9h0B1BMQlKdFA=";
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
