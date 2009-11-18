args: with args;

stdenv.mkDerivation rec {
  name = "redland-1.0.9";  

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

  patchPhase =
  ''
    sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl

    # Redland 1.0.9 uses an internal pre-processor symbol SQLITE_API
    # that collides with a symbol of the same name in sqlite 3.6.19.
    # This is a quick fix for the problem. A real solution needs to be
    # implemented upstream, though.
    find . -type f -exec sed -i -e 's/SQLITE_API/REDLAND_SQLITE_API/g' {} \;
  '';
}
