{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "imagick";

  version = "3.4.4";
  sha256 = "0xvhaqny1v796ywx83w7jyjyd0nrxkxf34w9zi8qc8aw8qbammcd";

  configureFlags = [ "--with-imagick=${pkgs.imagemagick.dev}" ];
  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pcre' ];

  meta.maintainers = lib.teams.php.members;
}
