args: with args;

let name = "redland-${version}";
in 

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sf/librdf/${name}.tar.gz";
    sha256 = "8a77fcfd20fea2c6e53761d6dcbbee3fdb35e5308de36c1daa0d2014e5a96afe";
  };
  
  buildInputs = [pkgconfig librdf_raptor];
  
  propagatedBuildInputs = [
    bdb openssl libxslt perl mysql postgresql sqlite curl pcre libxml2
    librdf_rasqal librdf_raptor
  ];
    
  configureFlags = "--with-threads --with-bdb=${bdb}";
  
  patchPhase = "sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
