{stdenv, fetchsvn, autotools, which, aterm, sdf}: derivation {
  name = "strategoxt-0.9.4-4785";
  system = stdenv.system;
  builder = ./svnbuilder.sh;
  src = fetchsvn {
    url = https://svn.cs.uu.nl:12443/repos/StrategoXT/trunk/StrategoXT;
    rev = "4785";
  };
  stdenv = stdenv;

  make     = autotools.make;
  automake = autotools.automake;
  autoconf = autotools.autoconf;
  libtool  = autotools.libtool;
  which    = which;

  aterm = aterm;
  sdf = sdf;
}
