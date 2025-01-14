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

  version = "3.7.0";
  sha256 = "sha256-WjZDVBCQKdIkvLsuguFbJIvptkEif0XmNCXAZTF5LT4=";

  configureFlags = [ "--with-imagick=${imagemagick.dev}" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre2 ];

  patches = lib.optionals (lib.versionAtLeast php.version "8.4") [
    # PHP 8.4 compatibility patch based on https://github.com/Imagick/imagick/pull/690
    # These is also an alternative https://github.com/Imagick/imagick/pull/704
    # Which includes more changes but doesn't apply cleanly.
    (fetchpatch {
      url = "https://github.com/Imagick/imagick/commit/65e27f2bc02e7e8f1bf64e26e359e42a1331fca1.patch";
      hash = "sha256-I0FwdqtQ/Y/QVkCl+nWPBIxsdQY6qcjdwiA/BaLNl7g=";
    })
  ];

  meta = with lib; {
    description = "Imagick is a native php extension to create and modify images using the ImageMagick API";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/imagick";
    maintainers = teams.php.members;
  };
}
