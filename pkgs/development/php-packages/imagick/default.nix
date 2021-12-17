{ buildPecl, lib, imagemagick, pkg-config, pcre2 }:

buildPecl {
  pname = "imagick";

  version = "3.6.0";
  sha256 = "sha256-Till8tcN1ZpA55V9VuWQ5zHK0maen4ng/KFZ10jSlH4=";

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
