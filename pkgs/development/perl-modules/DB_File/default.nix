{fetchurl, buildPerlPackage, db4}:

buildPerlPackage rec {
  name = "DB_File-1.826";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "c39828ef3cfecff8197ff057cb1c6127b87107c051d182b87c6b9ac79d23f09c";
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
    mkdir -p $out/lib/perl5/site_perl/
    cp -R $out/lib/perl5/5* $out/lib/perl5/site_perl
  '';
}
