{ stdenv, fetchurl, pkgconfig, openssl, libxslt, perl
, curl, pcre, libxml2, librdf_rasqal, librdf_raptor
, mysql ? null, postgresql ? null, sqlite ? null, bdb ? null
}:

stdenv.mkDerivation rec {
  name = "redland-1.0.10";  

  src = fetchurl {
    url = "mirror://sf/librdf/${name}.tar.gz";
    sha256 = "05cq722qvw5sq08qbydzjv5snqk402cbdsy8s6qjzir7vq2hs1p3";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [
    bdb openssl libxslt perl mysql postgresql sqlite curl pcre libxml2
    librdf_raptor librdf_rasqal
  ];

  configureFlags =
    [ "--with-threads" ]
    ++ stdenv.lib.optional (bdb != null) "--with-bdb=${bdb}";
  
  patchPhase ="sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
