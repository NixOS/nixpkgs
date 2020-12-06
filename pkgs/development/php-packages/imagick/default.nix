{ buildPecl, fetchpatch, lib, pkgs, pcre' }:

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
  ];

  configureFlags = [ "--with-imagick=${pkgs.imagemagick.dev}" ];
  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pcre' ];

  meta.maintainers = lib.teams.php.members;
}
