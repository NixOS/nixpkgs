{fetchurl, buildPerlPackage, db}:

buildPerlPackage rec {
  name = "DB_File-1.842";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0w2d99vs9qarng2f9fpg3gchfdzy6an13507jhclcl8wv183h5hg";
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
