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
    LIB = ${db}/lib
    INCLUDE = ${db}/include
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
