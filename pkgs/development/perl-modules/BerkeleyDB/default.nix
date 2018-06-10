{buildPerlPackage, fetchurl, db}:

buildPerlPackage rec {
  name = "BerkeleyDB-0.55";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0kz40wqr7qwag43qnmkpri03cjnqwzb0kj0vc9aw9yz2qx0y2a3g";
  };

  preConfigure = ''
    echo "LIB = ${db.out}/lib" > config.in
    echo "INCLUDE = ${db.dev}/include" >> config.in
  '';
}
