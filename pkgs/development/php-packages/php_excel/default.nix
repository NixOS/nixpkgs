{ buildPecl, fetchurl, lib, pkgs }:
let
  pname = "php_excel";
  phpVersion = "php7";
  version = "1.0.2";
in
buildPecl {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/iliaal/php_excel/releases/download/Excel-1.0.2-PHP7/excel-${version}-${phpVersion}.tgz";
    sha256 = "0dpvih9gpiyh1ml22zi7hi6kslkilzby00z1p8x248idylldzs2n";
  };

  buildInputs = with pkgs; [ libxl ];

  configureFlags = [
    "--with-excel"
    "--with-libxl-incdir=${pkgs.libxl}/include_c"
    "--with-libxl-libdir=${pkgs.libxl}/lib"
  ];

  meta.maintainers = lib.teams.php.members;
}
