{fetchurl, buildPerlPackage, db4}:

buildPerlPackage {
  name = "DB_File-1.816";
  
  src = fetchurl {
    url = mirror://cpan/authors/id/P/PM/PMQS/DB_File-1.816.tar.gz;
    sha256 = "1a668hk5v0l180kbqss2hq9khl756cmrykn8fz1rl4qzsp6lq284";
  };

  preConfigure = ''
    cat > config.in <<EOF
    PREFIX = size_t
    HASH = u_int32_t
    LIB = ${db4}/lib
    INCLUDE = ${db4}/include
    EOF
  '';
}
