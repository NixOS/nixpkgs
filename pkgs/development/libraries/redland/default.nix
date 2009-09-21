args: with args;

stdenv.mkDerivation rec {
  name = "redland-1.0.9";

  src = fetchurl {
    url = "mirror://sf/librdf/${name}.tar.gz";
    sha256 = "090mkrbssj9lm7hifkdrm7397sqcw0wx2ydz60iwrm2x9zcdx45a";
  };
  
  buildInputs = [pkgconfig librdf_raptor];
  
  propagatedBuildInputs = [
    bdb openssl libxslt perl mysql postgresql sqlite curl pcre libxml2
    librdf_rasqal librdf_raptor
  ];
    
  configureFlags = "--with-threads --with-bdb=${bdb}";
  
  patchPhase = "sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
