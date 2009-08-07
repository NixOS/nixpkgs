{ stdenv, fetchurl, apr, expat
, bdbSupport ? false, db4 ? null
}:

assert bdbSupport -> db4 != null;

stdenv.mkDerivation rec {
  name = "apr-util-1.3.9";
  
  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "10zcy1an5xkjx8nflirvm2a8rnp9psckws6r7xr5wq6ffxnafhc7";
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

