{stdenv, fetchsvn, autoconf, automake, libtool, which, aterm, sdf}:

stdenv.mkDerivation {
  name = "strategoxt-0.9.4-4792";

  builder = ./svnbuilder.sh;
  src = fetchsvn {
    url = https://svn.cs.uu.nl:12443/repos/StrategoXT/trunk/StrategoXT;
    rev = "4792";
    md5 = "0a7bba2cabfc7a9e2b9b5b43ddb3b7ad";
  };

  buildInputs = [autoconf automake libtool which aterm sdf];
  inherit aterm sdf libtool;
}
