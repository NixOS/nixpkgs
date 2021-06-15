{ buildPecl, fetchpatch, lib, imagemagick, pkg-config, pcre2 }:

buildPecl {
  pname = "imagick";

  version = "3.4.4";
  sha256 = "0xvhaqny1v796ywx83w7jyjyd0nrxkxf34w9zi8qc8aw8qbammcd";

  patches = [
    # Fix compatibility with PHP 8.
    (fetchpatch {
      url = "https://github.com/Imagick/imagick/pull/336.patch";
      sha256 = "nuRdh02qaMx0s/5OzlfWjyYgZG1zgrYnAjsZ/UVIrUM=";
    })
    # Fix detection of ImageMagick 7.
    (fetchpatch {
      url = "https://github.com/Imagick/imagick/commit/09551fbf38c16cdaf4ade7c08744501cd82d2747.patch";
      sha256 = "qUeQHP08kKOzuQdEpR8RSZ18Yhi0U9z24KwQcAx1UVg=";
    })
  ];

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
