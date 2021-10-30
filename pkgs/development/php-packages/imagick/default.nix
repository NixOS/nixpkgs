{ buildPecl, lib, imagemagick, pkg-config, pcre2 }:

buildPecl {
  pname = "imagick";

  version = "3.5.0";
  sha256 = "0afjyll6rr79am6d1p041bl4dj44hp9z4gzmlhrkvkdsdz1vfpbr";

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
