{ stdenv, fetchurl, apr, expat
, bdbSupport ? false, db4 ? null
}:

assert bdbSupport -> db4 != null;

stdenv.mkDerivation {
  name = "apr-util-1.2.12";
  
  src = fetchurl {
    url = http://archive.apache.org/dist/apr/apr-util-1.2.12.tar.bz2;
    sha256 = "152xwaxikp22acz7ypqsvlyjxhak6p40805wwbw7hcg1gyg2scyl";
  };
  
  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    ${if bdbSupport then "--with-berkeley-db=${db4}" else ""}
  '';
  
  passthru = {
    inherit bdbSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
  };
}

