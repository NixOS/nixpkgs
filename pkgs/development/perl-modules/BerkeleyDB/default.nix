{buildPerlPackage, fetchurl, db4}:

buildPerlPackage rec {
  name = "BerkeleyDB-0.36";
  
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "07xf50riarb60l1h6m2dqmql8q5dij619712fsgw7ach04d8g3z1";
  };

  preConfigure = ''
    echo "LIB = ${db4}/lib" > config.in
    echo "INCLUDE = ${db4}/include" >> config.in
  '';
}
