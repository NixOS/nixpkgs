{fetchurl, buildPerlPackage, db4}:

buildPerlPackage {
  name = "DB_File-1.820";
  
  src = fetchurl {
    url = mirror://cpan/authors/id/P/PM/PMQS/DB_File-1.820.tar.gz;
    sha256 = "0jnz5lsrad67j42sdw5bqpkmgiyj45rpiqgkff3i21252k9d5s7a";
  };

  preConfigure = ''
    cat > config.in <<EOF
    PREFIX = size_t
    HASH = u_int32_t
    LIB = ${db4}/lib
    INCLUDE = ${db4}/include
    EOF
  '';

  # I don't know about perl paths, but PERL5LIB env var is managed through
  # lib/perl5/site_perl, and the *.pm should be inside lib/perl5/site_perl/...
  # for other packages to get that in the PERL5LIB env var.
  postInstall = ''
    ensureDir $out/lib/perl5/site_perl/
    cp -R $out/lib/perl5/5* $out/lib/perl5/site_perl
  '';
}
