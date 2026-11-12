{
  buildPecl,
  lib,
  fetchpatch,
  imagemagick,
  pkg-config,
  pcre2,
}:

buildPecl {
  pname = "imagick";

  version = "3.8.1";
  hash = "sha256-OjWHwKUkwX0NrZZzoWC5DNd26DaDhHThc7VJ7YZDUu4=";

  patches = [
    # Support PHP 8.6, backported from upstream master
    (fetchpatch {
      name = "php86-offsetof.patch";
      url = "https://github.com/Imagick/imagick/commit/b580a705e2c879924bfaee2e1ed3a93c9cb3fcfb.patch";
      hash = "sha256-DOW/HuYJmXrkwHolvIPk3M1ikrCHKhHMeP9gJqanv+s=";
    })
  ];

  configureFlags = [ "--with-imagick=${imagemagick.dev}" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pcre2 ];

  meta = {
    description = "Imagick is a native php extension to create and modify images using the ImageMagick API";
    license = lib.licenses.php301;
    homepage = "https://pecl.php.net/package/imagick";
    teams = [ lib.teams.php ];
  };
}
