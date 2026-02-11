{
  buildPecl,
  fetchpatch,
  lib,
  imagemagick,
  pkg-config,
  pcre2,
  php,
}:

buildPecl {
  pname = "imagick";

  version = "3.8.1";
  sha256 = "sha256-OjWHwKUkwX0NrZZzoWC5DNd26DaDhHThc7VJ7YZDUu4=";

  configureFlags = [ "--with-imagick=${imagemagick.dev}" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre2 ];

  meta = {
    description = "Imagick is a native php extension to create and modify images using the ImageMagick API";
    license = lib.licenses.php301;
    homepage = "https://pecl.php.net/package/imagick";
    teams = [ lib.teams.php ];
  };
}
