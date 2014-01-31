{buildPerlPackage, fetchurl, db}:

buildPerlPackage rec {
  name = "BerkeleyDB-0.54";
  
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "010e66d0034b93a8397c600da320611149aef7861eaf1f93b95e49ae37b825b8";
  };

  preConfigure = ''
    echo "LIB = ${db}/lib" > config.in
    echo "INCLUDE = ${db}/include" >> config.in
  '';
}
