{ stdenv, fetchurl, buildPerlPackage, DBI, TestNoWarnings, oracle-instantclient }:

buildPerlPackage {
  pname = "DBD-Oracle";
  version = "1.80";

  src = fetchurl {
    url = mirror://cpan/authors/id/Z/ZA/ZARQUON/DBD-Oracle-1.76.tar.gz;
    sha256 = "1wym2kc8b31qa1zb0dgyy3w4iqlk1faw36gy9hkpj895qr1pznxn";
  };

  ORACLE_HOME = "${oracle-instantclient.lib}/lib";

  buildInputs = [ TestNoWarnings oracle-instantclient ] ;
  propagatedBuildInputs = [ DBI ];

  postBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath "${oracle-instantclient.lib}/lib" blib/arch/auto/DBD/Oracle/Oracle.bundle
  '';
}
