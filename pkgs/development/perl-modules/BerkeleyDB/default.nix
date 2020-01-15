{buildPerlPackage, fetchurl, db}:

buildPerlPackage {
  pname = "BerkeleyDB";
  version = "0.61";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/BerkeleyDB-0.61.tar.gz";
    sha256 = "0l65v301cz6a9dxcw6a4ps2mnr5zq358yn81favap6i092krggiz";
  };

  preConfigure = ''
    echo "LIB = ${db.out}/lib" > config.in
    echo "INCLUDE = ${db.dev}/include" >> config.in
  '';
}
