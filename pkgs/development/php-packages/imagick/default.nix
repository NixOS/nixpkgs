{
  buildPecl,
  lib,
  imagemagick,
  pkg-config,
  pcre2,
}:

buildPecl {
  pname = "imagick";

  version = "3.7.0";
  sha256 = "sha256-WjZDVBCQKdIkvLsuguFbJIvptkEif0XmNCXAZTF5LT4=";

  configureFlags = [ "--with-imagick=${imagemagick.dev}" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "Imagick is a native php extension to create and modify images using the ImageMagick API";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/imagick";
    maintainers = teams.php.members;
  };
}
