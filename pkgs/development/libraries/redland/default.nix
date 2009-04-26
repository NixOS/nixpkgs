args: with args;

stdenv.mkDerivation rec {
  name = "redland-1.0.7";

  src = fetchurl {
    url = "mirror://sf/librdf/${name}.tar.gz";
    sha256 = "1z160hhrnlyy5c8vh2hjza6kdfmzml8mg9dk8yffifkhnxjq5r2z";
  };
  
  buildInputs = [pkgconfig];
  
  propagatedBuildInputs = [
    bdb openssl libxslt perl mysql postgresql sqlite curl pcre libxml2
  ];
    
  configureFlags = "--with-threads --with-bdb=${bdb}";
  
  patchPhase = "sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
