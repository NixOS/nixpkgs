{ fetchurl, buildPerlPackage, DBI, libmysql }:

buildPerlPackage rec {
  name = "DBD-mysql-4.031";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAPTTOFU/${name}.tar.gz";
    sha256 = "1lngnkfi71gcpfk93xhil2x9i3w3rqjpxlvn5n92jd5ikwry8bmf";
  };

  buildInputs = [ libmysql ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
