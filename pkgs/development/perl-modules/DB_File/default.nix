{fetchurl, buildPerlPackage, db}:

buildPerlPackage rec {
  name = "DB_File-1.841";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "11fks42kgscpia0mxx4lc9krm7q4gv6w7m5h3m2jr3dl7viv36hn";
  };

  preConfigure = ''
    cat > config.in <<EOF
    PREFIX = size_t
    HASH = u_int32_t
    LIB = ${db.out}/lib
    INCLUDE = ${db.dev}/include
    EOF
  '';
}
