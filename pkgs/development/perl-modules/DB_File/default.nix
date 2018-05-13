{fetchurl, buildPerlPackage, db}:

buildPerlPackage rec {
  name = "DB_File-1.831";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0hq2vvcsa3nkb5bpcl0nkfsxhk8wyrsp3p3ara18rscrfd783hjs";
  };

  preConfigure = ''
    cat > config.in <<EOF
    PREFIX = size_t
    HASH = u_int32_t
    LIB = ${db.lib}/lib
    INCLUDE = ${db}/include
    EOF
  '';
}
