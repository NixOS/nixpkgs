args: with args;

let name = "redland-${version}";
in 

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sf/librdf/${name}.tar.gz";
    sha256 = "aa90ded84f5dd4cc2330bf79d139e00ceb93c6a9b94d17e1a93449ad579e1524";
  };
  
  buildInputs = [pkgconfig];
  
  propagatedBuildInputs = [
    bdb openssl libxslt perl mysql postgresql sqlite curl pcre libxml2
    librdf_raptor librdf_rasqal
  ];
    
  configureFlags = "--with-threads --with-bdb=${bdb}";
  
  patchPhase = "sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
