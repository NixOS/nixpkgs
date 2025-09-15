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

  version = "3.8.0";
  sha256 = "sha256-vaZ0YchU8g1hBXgrdpxST8NziLddRIHZUWRNIWf/7sY=";

  configureFlags = [ "--with-imagick=${imagemagick.dev}" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "Imagick is a native php extension to create and modify images using the ImageMagick API";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/imagick";
    teams = [ teams.php ];
  };
}
