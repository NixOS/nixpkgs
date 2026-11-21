{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
  zlib,
}:

buildPecl (finalAttrs: {
  pname = "spx";
  version = "0.4.22";

  src = fetchFromGitHub {
    owner = "NoiseByNorthwest";
    repo = "php-spx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P53g/o4i+QETWdErZaGA3AREvnr8kL9h0B1BMQlKdFA=";
  };

  configureFlags = [
    "--with-zlib-dir=${zlib.dev}"
    "--with-spx-assets-dir=${placeholder "out"}/share/misc/php-spx/assets/"
  ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/NoiseByNorthwest/php-spx/releases/tag/v${finalAttrs.version}";
    description = "Simple & straight-to-the-point PHP profiling extension with its built-in web UI";
    homepage = "https://github.com/NoiseByNorthwest/php-spx";
    license = lib.licenses.php301;
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
