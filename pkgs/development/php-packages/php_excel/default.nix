{ buildPecl, fetchurl, lib, libxl, php }:
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

  buildInputs = [ libxl ];

  configureFlags = [
    "--with-excel"
    "--with-libxl-incdir=${libxl}/include_c"
    "--with-libxl-libdir=${libxl}/lib"
  ];

  meta = with lib; {
    description = "PHP Extension interface to the Excel writing/reading library";
    license = licenses.php301;
    homepage = "https://github.com/iliaal/php_excel";
    maintainers = lib.teams.php.members;
    broken = lib.versionAtLeast php.version "8.0";
  };
}
