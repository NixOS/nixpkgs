{
  buildPecl,
  lib,
  fetchFromGitHub,
  zlib,
}:

let
  version = "0.4.20";
in
buildPecl {
  inherit version;
  pname = "spx";

  src = fetchFromGitHub {
    owner = "NoiseByNorthwest";
    repo = "php-spx";
    rev = "v${version}";
    hash = "sha256-2MOl9waWY3zK5NzQ19TJKK8kE7xC4K+e9AwV+wyAHZc=";
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
